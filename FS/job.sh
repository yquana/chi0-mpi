#!/bin/bash -l
# NOTE the -l flag!
#SBATCH -t 400:00:00
#SBATCH -J bench
#SBATCH -N 1
#SBATCH --mem 30GB
#SBATCH -p med
#SBATCH -n 1
#SBATCH -o bench-%j.output
#SBATCH -e bench-%j.output

hostname
which mpirun

module load intel

#module load intel-mkl
#module load scalapack
#module load quantum-espresso/6.3

#source ~/.bashrc

#mkdir -p /scratch/$SLURM_JOBID/XH3
#cp -r * /scratch/$SLURM_JOBID/XH3
#cd /scratch/$SLURM_JOBID/XH3

srun  ../bin/chi0.x

#srun /home/tbquan/program/q-e-mpich-local/bin/pw.x -inp scf.in
#srun /home/tbquan/program/q-e-mpich-local/bin/ph.x -inp ph.in
#srun /home/tbquan/program/q-e-mpich-local/bin/ph.x -inp ph1.in

#rm *.wfc*
#rm _ph0/*/*.wfc*
#rm -r *.save
#mkdir bak
#mv * bak
#mv bak $SLURM_SUBMIT_DIR
