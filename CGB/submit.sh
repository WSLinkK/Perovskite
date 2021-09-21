#!/bin/bash

#SBATCH --partition=skx-normal              # Partition (job queue)
#SBATCH --no-requeue                    # Return job to the queue if preempted
#SBATCH --job-name=CGB_WC            # Assign an short name to your job
#SBATCH --nodes=4                    # Number of nodes you require
#SBATCH --ntasks=192                   # Total # of tasks across all nodes
#SBATCH --cpus-per-task=1            # Cores per task (>1 if multithread tasks)
#SBATCH --time=48:00:00                 # Total run time limit (DD-HH:MM:SS)
#SBATCH --output=slurm.%N.%j.o     # STDOUT file for SLURM output
#SBATCH --error=slurm.%N.%j.err     # STDOUT file for SLURM output


## Environment settings needed for this job
module purge
module load gcc/7.1.0 impi/18.0.2 cmake/3.16.1 mkl/18.0.2
source /home1/08408/tg877074/PACKAGES/CP2K/cp2k-8.1/tools/toolchain/install/setup
cp2k=/home1/08408/tg877074/PACKAGES/CP2K/cp2k-8.1/exe/local/cp2k.popt
export PATH=/home1/08408/tg877074/PACKAGES/python-3.8.10/bin:$PATH

# Launch MPI code... 
export OMP_NUM_THREADS=1

# find out local IP
LOCALIP=$(/sbin/ip addr | grep -A 2 'ib0' | grep 'inet ' | awk '{ print $2 }' | awk '{t=length($0)}END{print substr($0,0,t-3)}')
echo $LOCALIP

input_file=CGB_WC.inp
output_file=CGB_WC.out

ibrun $cp2k -i $input_file -o $output_file   # Use ibrun instead of mpirun or mpiexec

