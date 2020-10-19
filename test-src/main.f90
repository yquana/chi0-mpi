        program main
            ! A code for calculating bare susceptibility from Wannier
            ! functions fitting.
            use mpi
            use params

            implicit none
            integer  :: ierr
            double complex :: ma(2,2), mb(2,2), mc(5)

           
            call MPI_INIT(ierr)
            call MPI_COMM_SIZE(MPI_COMM_WORLD, mp_size, ierr)
            call MPI_COMM_RANK(MPI_COMM_WORLD, mp_rank, ierr)

            ma(1,1) = (1d0,1d0) * (mp_rank + 1)
            ma(1,2) = 2d0 *( mp_rank + 1)
            ma(2,1) = 3d0 * (mp_rank + 1)
            ma(2,2) = 4d0 *( mp_rank + 1)

            print *, mb, ma
            print *, sizeof(ma)
            call MPI_Reduce(ma, mb, 4, MPI_double_complex, MPI_SUM, 0, MPI_COMM_WORLD, ierr)
            if (mp_rank .eq. 0) then
                    print *, mb, ma
            endif

            call MPI_FINALIZE(ierr)
            if (ierr .ne. MPI_SUCCESS) then
                    print *, "MPI not finalized"
            endif
        end
