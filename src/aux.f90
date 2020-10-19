     module aux
      implicit none

         contains

         subroutine get_work_space()
                use params
                implicit none
                external :: zheevr
                double precision            :: kx, ky, kz, phase, abstol, w(nwan)
                double complex              :: ham(nwan, nwan), z(nwan, nwan)
                integer                     :: i, m, isuppz(2*nwan), info


                write(*,*) 'get_work_space'

                ham = (0d0, 0d0)
                !print *,'test', mp_kx(:)
                kx = mp_kx(1)
                ky = mp_ky(1)
                kz = mp_kz(1)

                !print *, kx, ky, kz

                allocate(rwork(1), work(1), iwork(1))
                abstol = 1d-5
                do i = 1, nhop
                    phase = kx * hop_r(i)%hop_x + ky * hop_r(i)%hop_y + kz * hop_r(i)%hop_z
                    ham(site(i)%i, site(i)%j) = ham(site(i)%i, site(i)%j) + &
                         &hop(i)%hop * cdexp( (0d0, 1d0) * phase)
                end do
                call zheevr('V', 'A', 'U', nwan, ham, nwan, 0d0, 0d0, 0, 0, abstol, m, &
                & w, z, nwan, isuppz, work, -1, rwork, -1, iwork, -1, info)
                lwork = int(work(1))
                liwork = int(iwork(1))
                lrwork = int(rwork(1))
                deallocate(work, iwork, rwork)
                allocate(work(lwork),source=(0d0,0d0))
                allocate(rwork(lrwork),source=0d0)
                allocate(iwork(liwork),source=0)

            end subroutine

     end module
