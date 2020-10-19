        module init
          implicit none
          
          contains
          subroutine read_input()
            use params
            implicit none
            integer                          :: i,  nkpt, kden
            double precision, allocatable    :: kx(:), ky(:), kz(:)
            double precision                 :: vol, factor

            qind = 0
            
            open(unit=200, file='chi.in')
            read(200, nml=input) 
            open(unit=204, file=trim(adjustl(fhop)))
            read(204,*) a(1,:)
            read(204,*) a(2,:)
            read(204,*) a(3,:)
            
            vol =  a(1,1) * (a(2,2) * a(3,3) - a(2,3) * a(3,2)) + &
                 & a(1,2) * (a(2,3) * a(3,1) - a(2,1) * a(3,3)) + &
                 & a(1,3) * (a(2,1) * a(3,2) - a(2,2) * a(3,1))
                 
            factor = 2d0 * pi / vol
                 
            b(1,1) = a(2,2) * a(3,3) - a(2,3) * a(3,2)
            b(1,2) = a(2,3) * a(3,1) - a(2,1) * a(3,3)
            b(1,3) = a(2,1) * a(3,2) - a(2,2) * a(3,1)
            
            b(2,1) = a(3,2) * a(1,3) - a(3,3) * a(1,2)
            b(2,2) = a(3,3) * a(1,1) - a(3,1) * a(1,3)
            b(2,3) = a(3,1) * a(1,2) - a(3,2) * a(1,1)
            
            b(3,1) = a(1,2) * a(2,3) - a(1,3) * a(2,2)
            b(3,2) = a(1,3) * a(2,1) - a(1,1) * a(2,3)
            b(3,3) = a(1,1) * a(2,2) - a(1,2) * a(2,1)
            
            b(:,:) = factor * b(:,:)
            
            if (mp_rank .eq. 0) then
                write(*,"(A6,3f18.10)") "a(1)", a(1,:)
                write(*,"(A6,3f18.10)") "a(2)", a(2,:)
                write(*,"(A6,3f18.10)") "a(3)", a(3,:)
                write(*,"(A6,3f18.10)") "b(1)", b(1,:)
                write(*,"(A6,3f18.10)") "b(2)", b(2,:)
                write(*,"(A6,3f18.10)") "b(3)", b(3,:)
            end if

            write(*,*) "Finished reading input"
            
            if (mode .eq. 'band') then
                read(200,*) nkpt
                allocate(kx(nkpt), ky(nkpt), kz(nkpt), source=0d0)
                do i = 1, nkpt 
                    read(200,*)  kx(i), ky(i), kz(i), kden
                    num_k  = num_k + kden
                end do
                num_k = num_k - kden
                allocate(mp_kx(num_k), mp_ky(num_k), mp_kz(num_k), source=0d0)
                call get_kmesh_path(kx, ky, kz, nkpt)
            else if (mode .eq. 'band2d') then
                read(200,*) nkx, nky
                num_k = nkx * nky
                allocate(mp_kx(num_k), mp_ky(num_k), mp_kz(num_k))
                allocate(kx(3), ky(3), kz(3), source=0d0)
                do i = 1, 3
                    read(200,*) kx(i), ky(i), kz(i)
                end do
                call get_kmesh_2d(kx, ky, kz)
            else if (mode .eq. 'band3d') then
                read(200,*) nkx, nky, nkz
                num_k = nkx * nky * nkz
                !print *, 'num_k',num_k
                allocate(mp_kx(num_k), mp_ky(num_k), mp_kz(num_k))
                allocate(kx(4), ky(4), kz(4), source=0d0)
                do i = 1, 4
                    read(200,*) kx(i), ky(i), kz(i)
                end do
                call get_kmesh_3d(kx, ky, kz)
            else if (mode .eq. 'chi') then
                num_k = nkx * nky * nkz
                allocate(mp_kx(nkx*nky*nkz), source=0d0)
                allocate(mp_ky(nkx*nky*nkz), source=0d0)
                allocate(mp_kz(nkx*nky*nkz), source=0d0)
                call get_kmesh_full()
                if (qmode .eq. 0) then
                    write(*,*) "q-mesh generated from nqx, nqy, nqz."
                    call gen_q_mesh()
                else if (qmode .eq. -1) then
                     num_q = 1
                     allocate(mp_qx(1), mp_qy(1), mp_qz(1))
                    read(200, *) mp_qx(1), mp_qy(1), mp_qz(1)
                else if ( qmode .gt. 0 .and. int(qmode) .eq. qmode) then
                    write(*,*) "q subdivision, div_x/div_y/div_z:", qmode
                    call gen_q_mesh()
                end if
            end if
            
            read(204,*) nhop, nwan
            allocate(hop(nhop))
            allocate(hop_r(nhop))
            allocate(site(nhop))
            allocate(ek(nkx*nky*nkz, nwan))
            allocate(wan_pos(nwan,3))
            
            do i = 1, nhop
                    read(204, fmt)  site(i)%i, site(i)%j, hop_r(i)%hop_x, &
                    & hop_r(i)%hop_y, hop_r(i)%hop_z, hop(i)%hop
            end do
            write(*,*) "Finished reading hopping parameters"
          end subroutine
          
          subroutine get_q_per_core()
            use params
            implicit none
            integer         :: i, j, k
            
            num_q      = nqx * nqy * nqz
            q_per_core = int(num_q / mp_size)
            
            if (q_per_core * mp_size .ne. num_q ) then
                if (mp_rank .lt. num_q - q_per_core * mp_size) then
                    q_per_core = q_per_core + 1
                end if
            end if
            
          end subroutine
          
          subroutine get_kmesh_full()
            use params
            implicit none
            integer  i, j, k, ind
            double precision  :: kvec(3)
            do i = 0, nkx-1
              do j = 0, nky -1
                do k = 0, nkz - 1
                  ind = i * nky * nkz + j * nkz + k + 1
                  kvec(1) = float(i)/float(nkx)
                  kvec(2) = float(j)/float(nky)
                  kvec(3) = float(k)/float(nkz)
                  mp_kx(ind) = kvec(1) * b(1,1) + kvec(2) * b(2,1) + kvec(3) * b(3,1)
                  mp_ky(ind) = kvec(1) * b(1,2) + kvec(2) * b(2,2) + kvec(3) * b(3,2)
                  mp_kz(ind) = kvec(1) * b(1,3) + kvec(2) * b(2,3) + kvec(3) * b(3,3)
                end do
              end do
            end do
          end subroutine
          
          subroutine get_kmesh_path(kx, ky, kz, nkpt)
            use params
            implicit none
            integer, intent(in) :: nkpt
            double precision :: kx(nkpt), ky(nkpt), kz(nkpt), x, vec(3)
            integer     :: ind
            integer     :: i, j, k, kden
            
            kden = int(num_k/(nkpt-1))
            do i = 1, nkpt - 1
              do j = 0, kden - 1
                ind = (i - 1) * kden + j + 1
                x = float(j)/float(kden - 1)
                vec(1) = (1d0 - x) * kx(i) + x * kx(i + 1)
                vec(2) = (1d0 - x) * ky(i) + x * ky(i + 1)
                vec(3) = (1d0 - x) * kz(i) + x * kz(i + 1)
                mp_kx(ind) = vec(1) * b(1,1) + vec(2) * b(2,1) + vec(3) * b(3,1)
                mp_ky(ind) = vec(1) * b(1,2) + vec(2) * b(2,2) + vec(3) * b(3,2)
                mp_kz(ind) = vec(1) * b(1,3) + vec(2) * b(2,3) + vec(3) * b(3,3)
              end do
            end do
          end subroutine

          subroutine get_kmesh_2d(kx, ky, kz)
            use params
            implicit none
            double precision, intent(in),dimension(3)  :: kx, ky, kz
            integer   :: i, j,  ind
     
            double precision  :: x(2), vec(3)

            do i = 1, nkx
              do j = 1, nky
                ind = (i - 1) * nky + j
                x(1) = float(i - 1) / float(nkx)
                x(2) = float(j - 1) / float(nky)
                vec(1) = kx(1) + x(1) * (kx(2) - kx(1)) + x(2) * (kx(3) - kx(1))
                vec(2) = ky(1) + x(1) * (ky(2) - ky(1)) + x(2) * (ky(3) - ky(1))
                vec(3) = kz(1) + x(1) * (kz(2) - kz(1)) + x(2) * (kz(3) - kz(1))
                mp_kx(ind) = vec(1) * b(1,1) + vec(2) * b(2,1) + vec(3) * b(3,1)
                mp_ky(ind) = vec(1) * b(1,2) + vec(2) * b(2,2) + vec(3) * b(3,2)
                mp_kz(ind) = vec(1) * b(1,3) + vec(2) * b(2,3) + vec(3) * b(3,3)
              end do
            end do
          end subroutine

          subroutine get_kmesh_3d(kx, ky, kz)
              use params
              implicit none
              double precision, intent(in), dimension(4)  :: kx, ky, kz
              integer                                     :: i, j, k, ind

              double precision    :: x(3), vec(3)

              do i = 1, nkx
                do j = 1, nky
                  do k = 1, nkz
                      ind = (i - 1) * nky * nkz + (j - 1) * nkz + k
                      x(1) = float(i - 1)/float(nkx)
                      x(2) = float(j - 1)/float(nky)
                      x(3) = float(k - 1)/float(nkz)
                      vec(1) = kx(1) + x(1) * kx(2) + x(2) * kx(3) + x(3) * kx(4)
                      vec(2) = ky(1) + x(1) * ky(2) + x(2) * ky(3) + x(3) * ky(4)
                      vec(3) = kz(1) + x(1) * kz(2) + x(2) * kz(3) + x(3) * kz(4)
                      mp_kx(ind) = vec(1) * b(1,1) + vec(2) * b(2,1) + vec(3) * b(3,1)
                      mp_ky(ind) = vec(1) * b(1,2) + vec(2) * b(2,2) + vec(3) * b(3,2)
                      mp_kz(ind) = vec(1) * b(1,3) + vec(2) * b(2,3) + vec(3) * b(3,3)
                  end do
                end do
              end do
          end subroutine
          
          subroutine gen_q_mesh()
            use params
            implicit none
            integer     :: i, j, k, ind
            double precision :: kvec(3)
            
            if(qmode .eq. 0) then
              num_q = nqx * nqy * nqz
              allocate(mp_qx(num_q), mp_qy(num_q), mp_qz(num_q), source=0d0)
              do i = 0, nqx - 1
                do j = 0, nqy - 1
                  do k = 0, nqz - 1
                    ind = i * nqy * nqz + j  * nqz + k + 1
                    kvec(1) = float(i)/float(nqx)
                    kvec(2) = float(j)/float(nqy)
                    kvec(3) = float(k)/float(nqz)
                    mp_qx(ind) = kvec(1) * b(1,1) + kvec(2) * b(2,1) + kvec(3) * b(3,1)
                    mp_qy(ind) = kvec(1) * b(1,2) + kvec(2) * b(2,2) + kvec(3) * b(3,2)
                    mp_qz(ind) = kvec(1) * b(1,3) + kvec(2) * b(2,3) + kvec(3) * b(3,3)
                  end do
                end do
              end do
            else if (int(nkx/qmode) .ne. nkx/qmode .or. &
                 & int(nky/qmode) .ne. nky/qmode &
                 & .or. int(nkz/qmode) .ne. nkz/qmode) then
              stop ("nkx, nky or nkz can't be divided by qmode")
            else if(int(nkx/qmode) .eq. nkx/qmode .and. int(nky/qmode) .eq. nky/qmode &
              & .and. int(nkz/qmode) .eq. nkz/qmode) then
              nqx = int(nkx/qmode)
              nqy = int(nky/qmode)
              nqz = int(nkz/qmode)
              num_q = nqx * nqy * nqz
            end if
          end subroutine
        end module
