        module driver_routines
            implicit none
            
            interface gen_ene
                module procedure   get_ek, get_ek_co
                module procedure   write_ek, write_ek_co
            end interface
            
            contains
            subroutine driver()
                use params
                use init
                use aux
                implicit none
                integer     :: i, eunit, vunit

  
                write(*,*) "\-Compute workspace size"
                call get_work_space() 
                write(*,*) "-/Compute workspace size"
                ! compute lwork, liwork, lrwork etc for zheevr
                print *, mode
                if (trim(adjustl(mode)) .eq. 'chi') then
                  if (qind .eq. 0) then
                    do i = 1, num_q
                      write(*,*) "Q index!", i
                      call calc_chi0(i, 0d0)
                    end do
                  else if (qind .ne. 0) then
                    call calc_chi0(qind, 0d0)
                  end if
                else if (trim(adjustl(mode)) .eq. 'band') then
                   eunit = 4000
                   vunit = 5000 
                   open(unit=eunit, file="bands.dat")
                   open(unit=vunit, file="vec.dat")
                   write(*,*) "started calculating band structures"
                   call calc_ek(eunit, vunit)
                   write(*,*) "Finished calculating band structures"
                   close(eunit)
                   close(vunit)
                else if (trim(adjustl(mode)) .eq. 'band2d') then
                   eunit = 4000
                   vunit = 5000
                   open(unit=eunit, file="bands.dat")
                   open(unit=vunit, file="vec.dat")
                   call calc_ek(eunit, vunit)
                   close(eunit)
                   close(vunit)
                else if (trim(adjustl(mode)) .eq. 'band3d') then
                   eunit = 4000
                   vunit = 5000
                   write(*,*) "Band 3D"
                   open(unit=eunit, file="bands.dat")
                   open(unit=vunit, file="vec.dat")
                   call calc_ek(eunit, vunit)
                   close(eunit)
                   close(vunit)
                end if
            end subroutine
            
            subroutine calc_ek(eunit, vunit)
                use params
                implicit none
                integer, intent(in)  :: eunit, vunit
                integer              :: i
                
                do i = 1, num_k
                    call gen_ene(i, eunit, vunit)
                end do
            end subroutine
            
            subroutine get_ek(ind, eig, vec)
                use params
                external                      :: zheevr
                integer, intent(in)           :: ind
                double complex,intent(out)    :: vec(nwan,nwan)
                double precision,intent(out)  :: eig(nwan)
                double precision              :: kx, ky, kz, phase, abstol, w(nwan)
                double complex                :: ham(nwan, nwan), z(nwan, nwan)
                integer                       :: i,  m, isuppz(2*nwan), info


                
                ham    = (0d0, 0d0)
                z      = (0d0, 0d0)
                w      = 0d0
                kx     = mp_kx(ind)
                ky     = mp_ky(ind)
                kz     = mp_kz(ind)
                abstol = 1d-5
                 
                do i = 1, nhop
                    phase = kx * hop_r(i)%hop_x + ky * hop_r(i)%hop_y + kz * hop_r(i)%hop_z
                    ham(site(i)%i, site(i)%j) = ham(site(i)%i, site(i)%j) + &
                         &hop(i)%hop * cdexp( (0d0, 1d0) * phase)
                end do
                
                call zheevr('V', 'A', 'U', nwan, ham, nwan, 0d0, 0d0, 0, 0, abstol, m, &
                & w, z, nwan, isuppz, work, lwork, rwork, lrwork, iwork, liwork, info)
                print *, info
                eig = w
                vec = z
            end subroutine

            subroutine write_ek(ind,eunit, vunit)
                use params
                external                      :: zheevr
                integer, intent(in)           :: ind, eunit, vunit
                double complex                :: vec(nwan,nwan)
                double precision              :: eig(nwan)
                double precision              :: kx, ky, kz, phase, abstol, w(nwan)
                double complex                :: ham(nwan, nwan), z(nwan, nwan)
                integer                       :: i, j, m, isuppz(2*nwan), info

 
                ham    = (0d0, 0d0)
                kx     = mp_kx(ind)
                ky     = mp_ky(ind)
                kz     = mp_kz(ind)
                abstol = 1d-5
                 
                do i = 1, nhop
                    phase = kx * hop_r(i)%hop_x + ky * hop_r(i)%hop_y + kz * hop_r(i)%hop_z
                    ham(site(i)%i, site(i)%j) = ham(site(i)%i, site(i)%j) + &
                         &hop(i)%hop * cdexp( (0d0, 1d0) * phase)
                end do
                
                call zheevr('V', 'A', 'U', nwan, ham, nwan, 0d0, 0d0, 0, 0, abstol, m, &
                & w, z, nwan, isuppz, work, lwork, rwork, lrwork, iwork, liwork, info)
                eig = w
                vec = z

                write(eunit, '(f18.10, A5, f18.10, A5, f18.10)', &
                      & advance='no') kx,',', ky,',', kz 
                write(vunit, '(f18.10, A5, f18.10, A5, f18.10)', &
                      & advance='yes') kx,',', ky,',', kz

                do i = 1, nwan
                   write(eunit, '(A5, f18.10)', advance='no') ',',eig(i)
                   !write(vunit, '(f18.10, A5)', advance='no') eig(i),','
                   !do j = 1, nwan
                   !  write(vunit, '(2f18.10)', advance='no') vec(j,i)
                   !end do
                   !write(vunit,*)
                end do
                write(eunit, *)
                !write(vunit, *)
            end subroutine

            subroutine get_ek_co(kx, ky, kz, eig, vec)
                ! k-points are referenced by kx, ky and kz
                use params
                external :: zheevr
                double precision, intent(in)  :: kx, ky, kz
                double complex, intent(out)   :: vec(nwan,nwan)
                double precision,intent(out)  :: eig(nwan)
                double precision              :: phase, abstol, w(nwan)
                double complex                :: ham(nwan, nwan), z(nwan, nwan)
                integer                       :: i,  m, isuppz(2*nwan), info
              

                ham = (0d0, 0d0)
                z   = (0d0, 0d0)
                w   = 0d0

                abstol = 1d-5
                
                do i = 1, nhop
                    phase = kx * hop_r(i)%hop_x + ky * hop_r(i)%hop_y + kz * hop_r(i)%hop_z
                    ham(site(i)%i, site(i)%j) = ham(site(i)%i, site(i)%j) + &
                         &hop(i)%hop * cdexp( (0d0, 1d0) * phase)
                end do

                !print *, 'nwan', nwan, lwork, lrwork, liwork
                
                call zheevr('V', 'A', 'U', nwan, ham, nwan, 0d0, 0d0, 0, 0, abstol, m, &
                & w, z, nwan, isuppz, work, lwork, rwork, lrwork, iwork, liwork, info)
                eig = w
                vec = z

            end subroutine

            subroutine write_ek_co(kx, ky, kz, eunit, vunit)
                ! k-points are referenced by kx, ky and kz
                use params
                use green
                external :: zheevr
                integer, intent(in)           :: eunit, vunit
                double precision, intent(in)  :: kx, ky, kz
                double complex                :: vec(nwan,nwan)
                double precision              :: eig(nwan)
                double precision              :: phase, abstol, w(nwan)
                double complex                :: ham(nwan, nwan), z(nwan, nwan)
                integer                       :: i, j, m, isuppz(2*nwan), info
               
 
                ham = (0d0, 0d0)
                abstol = 1d-5
                
                do i = 1, nhop
                    phase = kx * hop_r(i)%hop_x + ky * hop_r(i)%hop_y + kz * hop_r(i)%hop_z
                    ham(site(i)%i, site(i)%j) = ham(site(i)%i, site(i)%j) + &
                         &hop(i)%hop * cdexp( (0d0, 1d0) * phase)
                end do
                
                call zheevr('V', 'A', 'U', nwan, ham, nwan, 0d0, 0d0, 0, 0, abstol, m, &
                & w, z, nwan, isuppz, work, lwork, rwork, lrwork, iwork, liwork, info)
                eig = w
                vec = z

                write(eunit, '(3f18.10)', advance='no') kx, ky, kz
                write(vunit, '(3f18.10)') kx, ky, kz

                do i = 1, nwan
                  write(eunit,'(f18.10)', advance='no') eig(i)
                  !write(vunit,'(f18.10)', advance='no') eig(i)
                  !do j = 1, nwan
                  !  write(vunit,'(2f18.10)', advance='no') z(j,i)
                  !end do
                end do
            end subroutine


            subroutine calc_chi0(inq, omega)
                use params
                use green
                use mpi
                implicit none
                
                integer, intent(in)                   :: inq
                double precision, intent(in)          :: omega
                integer                               :: i, j,  k
                integer,allocatable                   :: k_min(:), k_max(:)
                double precision                      :: kx_new, ky_new, kz_new 
                double precision                      :: eig0(nwan), eig1(nwan)
                double precision                      :: gam
                double complex                        :: vec0(nwan, nwan), vec1(nwan, nwan)
                double complex,allocatable            :: tmp1(:,:)
                double complex,allocatable            :: tmp2(:,:)
                double complex,allocatable            :: tmp3(:,:)
                double complex,allocatable            :: tmp4(:,:)
                double complex,allocatable            :: tmp5(:,:)
                character(len=20)                     :: name
                integer :: mp_ind, ierr, ndim


                ndim = nwan * nwan * nwan * nwan

                print *, mp_size , 'num_k',num_k, 'inq',inq
                allocate(k_min(mp_size),k_max(mp_size))
                if (mod(num_k, mp_size) .eq. 0 ) then
                  do i = 1, mp_size
                    k_min(i) = (i - 1) * num_k/mp_size + 1
                    k_max(i) = i * num_k/mp_size
                  end do
                else
                  do i = 1, mp_size -1
                    k_min(i) = (i - 1) * num_k/mp_size + 1
                    k_max(i) = i * num_k/mp_size
                  end do
                  k_min(mp_size) = num_k - mod(num_k,mp_size) + 1
                  k_max(mp_size) = num_k
                end if
                
                print *, 'qind, mp_rank', qind, mp_rank
                allocate(tmp1(nwan,nwan),source=(0d0,0d0))
                allocate(tmp2(nwan,nwan),source=(0d0,0d0))
                allocate(tmp3(nwan*nwan,nwan*nwan),source=(0d0,0d0))
                allocate(tmp4(nwan*nwan,nwan*nwan),source=(0d0,0d0))
                allocate(tmp5(nwan*nwan, nwan*nwan), source=(0d0,0d0))

                gam = 0.02

                mp_ind = mp_rank + 1
                do i = k_min(mp_ind), k_max(mp_ind)
                  write(*,*) 'k-index', i, k_min(mp_ind), k_max(mp_ind)
                  call gen_ene(mp_kx(i), mp_ky(i), mp_kz(i), eig0, vec0)
                  kx_new = mp_kx(i) + mp_qx(inq)
                  ky_new = mp_ky(i) + mp_qy(inq)
                  kz_new = mp_kz(i) + mp_qz(inq)
                  call gen_ene(kx_new, ky_new, kz_new, eig1, vec1)
                   
                  do j = 1, nwan
                    if (abs(eig0(j)) < fsthick) then
                      do k = 1, nwan
                        if (abs(eig1(k)) < fsthick) then
                          tmp1(:,:) = arr_mul(vec0(:,j), vec0(:,j), nwan)
                          tmp2(:,:) = arr_mul(vec1(:,k), vec1(:,k), nwan)
                          tmp2(:,:) = tmp2(:,:) * (gauss0(eig1(k)) - gauss0(eig0(j)))&
                              & / ( omega + eig1(k) - eig0(j) + gam * (0d0, 1d0))
                          tmp3(:,:) = arr_mul(tmp1(:,:),tmp2(:,:), nwan*nwan)
                          tmp4(:,:) = tmp3(:,:) + tmp4(:,:)
                        end if
                      end do
                    end if
                  end do
                end do

                tmp5 = (0d0,0d0)

                write(*,"(A5, 2f18.10,i4)") 'A11', tmp4(1,1), MPI_DOUBLE_COMPLEX
                write(*,"(A5, 2f18.10,i4)") 'A22', tmp4(2,2), MPI_DOUBLE_COMPLEX


                call MPI_Reduce(tmp4, tmp5, ndim , &
                              &MPI_DOUBLE_COMPLEX, MPI_SUM, &
                              &  0, MPI_COMM_WORLD, ierr)
                print *, "Reduce ierr", ierr
                if (mp_rank .eq. 0) then
                    open(unit=5000, file="chi-k")
                    write(5000,"(3f18.10)") mp_qx(inq), mp_qy(inq), mp_qz(inq)
                    do i = 1, nwan*nwan
                      do j = 1, nwan*nwan
                        write(5000,"(2I5,  2f18.10)") i, j, tmp5(i,j) 
                      end do
                    end do
                end if
                deallocate(k_min, k_max,tmp1,tmp2,tmp3,tmp4)
            end subroutine
            
            double precision function gauss0(enk)
                ! FD distribution
                use params
                implicit none
                double precision, intent(in)    :: enk
                
                gauss0 = 1e0 / (dexp((enk)/temp) + 1d0)
            end function
        end module
