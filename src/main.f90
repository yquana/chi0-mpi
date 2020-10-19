        program main
            ! A code for calculating bare susceptibility from Wannier
            ! functions fitting.
            use mpi
            use init
            use params
            use driver_routines

            implicit none
            integer  :: ierr

           
            call MPI_INIT(ierr)
            call MPI_COMM_SIZE(MPI_COMM_WORLD, mp_size, ierr)
            call MPI_COMM_RANK(MPI_COMM_WORLD, mp_rank, ierr)

            call read_input()
            call driver()

            call MPI_FINALIZE(ierr)
            if (ierr .ne. MPI_SUCCESS) then
                    print *, "MPI not finalized"
            endif
        end
