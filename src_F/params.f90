        module params
            implicit none
            
            integer     :: nkx, nky, nkz            ! k-mesh
            integer     :: nqx, nqy, nqz            ! q-mesh
            integer     :: nwan, nhop               ! number of Wannier functions
            integer     :: mp_size                  ! number of cpu cores
            integer     :: mp_rank                  ! rank of cpu core
            integer     :: q_lower, q_upper         ! q-limit for each cpu core
            integer     :: num_k                    ! total number of k-points
            integer     :: num_q                    ! total number of q-points
            integer     :: k_per_core               ! number of k-points for the current thread
            integer     :: q_per_core               ! number of q-points for the current thread
            integer     :: lwork, lrwork, liwork    ! workspace parameters
            integer     :: qmode                    ! mode for generating q-mesh
            integer     :: qind                     ! q-point index
            integer     :: nswi                     ! number of matsubara frequencies
            integer     :: kmode                    !


            double complex, allocatable       :: work(:)
            double precision, allocatable     :: rwork(:)
            integer, allocatable              :: iwork(:)
            double precision                  :: fsthick           ! energy window near the Fermi level
            character(len=30)                 :: mode              ! mode of calculation
            double precision                  :: a(3,3)
            double precision                  :: b(3,3)
            double precision, allocatable     :: wan_pos(:,:)
            double precision, allocatable     :: mp_kx(:), mp_ky(:), mp_kz(:)
            double precision, allocatable     :: mp_qx(:), mp_qy(:), mp_qz(:)
            double precision, allocatable     :: ek(:,:), chi0(:)
            double precision                  :: temp , gam
            double precision                  :: ef
            double precision, parameter       :: pi=3.1415926535897932384626 
            character(len=20), parameter      :: fmt="(2I8, 5f18.10)"
            character(len=20)                 :: fhop
            
            namelist /input/  nkx, nky, nkz, nqx, nqy, nqz, temp, num_q,&
                            &  fhop, qmode, nswi, mode, kmode, qind, &
                            & fsthick, ef, gam
            
            type hopping_def
                double complex      :: hop
            end type
            
            type hop_r_def
                double precision    :: hop_x
                double precision    :: hop_y
                double precision    :: hop_z
            end type
            
            type site_def
                integer     :: i, j
            end type
            
            type(hopping_def), allocatable  :: hop(:)
            type(hop_r_def),   allocatable  :: hop_r(:)
            type(site_def),    allocatable  :: site(:)

        end module
