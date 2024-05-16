                program main
                               implicit none
                               double complex  :: a(4000,1),b(1,4000),c(4000,4000)
                               integer  :: i, j, k

                               do i = 1, 3
                                   a(i, 1) = (0d0, 1d0) * dble(i)
                                   b(1, i) = (1d0, 0d0) * dble(i)
                               end do
                               c =matmul(a, b)
                end 

