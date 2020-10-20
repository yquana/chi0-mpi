FFLAGS=  -llapack -L/home/bitnami/github/lapack-3.8.0 -lrefblas #-check bounds   -mkl # -llapack -lrefblas  #-ltmglib
F90 = mpif90 #fortran -g
#gfortran

chi.x: main.f90 init.o params.o driver_routines.o green.o
	$(F90)   aux.o driver_routines.o params.o init.o green.o main.f90  $(FFLAGS) -o chi0.x
	cp chi0.x ../bin

params.o: params.f90
	$(F90) -c params.f90

green.o: green.f90
	$(F90)   -c green.f90

init.o: init.f90 params.o
	$(F90) -c init.f90

aux.o: aux.f90
	$(F90) -c aux.f90

driver_routines.o: driver_routines.f90 params.o green.o aux.o
	$(F90) $(FFLAGS) -c driver_routines.f90

clean:
	rm *.o *.mod chi0.x ../bin/chi0.x

test:
	cd ../test
	mpirun  -np 1 ../bin/chi0.x
