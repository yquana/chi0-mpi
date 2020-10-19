        module green
          implicit none
          
          contains 
          
          subroutine imag_green(eig, vec, wi)
            use params
            implicit none
            double precision, intent(in)     :: eig(nwan), wi
            double complex, intent(in)       :: vec(nwan, nwan)
            double complex                   :: green(nwan, nwan) 
            double complex                   :: aa(nwan, nwan)
            integer                          ::  i, j, k, l, m, n, funit
            character(len=20)                :: name
          
            green = (0d0, 0d0)
            do i = 1, nwan
                aa = arr_mul(vec(:,i), vec(:,i), nwan)
                green = green + aa/((0d0, 1d0) * wi - eig(i))
            end do
            
            write(name, *) mp_rank
            funit = 400 + mp_rank
            open(unit=funit, file='green'//trim(adjustl(name)))
            do i = 1, nwan
              do j = 1, nwan
                write(funit, '(2f18.10)', advance='no') green(i,j)
              end do
              write(funit, *)
            end do
            write(funit, *)
          end subroutine
          
          function arr_mul(arr1, arr2, n) result(arr)
            use params
            implicit none
            
            integer, intent(in)        :: n  ! array size
            double complex,intent(in)  :: arr1(n), arr2(n)
            double complex             :: l_a(n,1), r_a(1,n), arr(n,n)

            !print *,'r_a', sizeof(r_a), sizeof(arr2)
            
            l_a(:,1) = arr1(:)
            r_a(1,:) = conjg(arr2)

            
            arr = matmul(l_a , r_a)
          end function
          
        end module
