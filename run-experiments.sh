#!/bin/sh

# Experiment parameters
export NUM_THREADS=8 # Range to be evaluated: 1..NUM_THREADS
export NUM_MEASUREMENTS=10 # No. of measurements per each thread experiment
export NUM_CONVERGENCE_IT=100 # No. of convergence iterations
export NUM_MESH_NODES=6500000 # No. of mesh nodes

# Clear data files and compile C code
rm -rf *.dat *.png
gcc -o diffusion_parallel_test -fopenmp diffusion_parallel_test.c -lm

# Run experiments
echo "No. threads,Time" >> diffusion_parallel_test_julia.dat
echo "No. threads,Time" >> diffusion_parallel_test_c.dat

for I in `seq 1 $NUM_MEASUREMENTS`;
do
    for NUM_THREADS in `seq 1 $NUM_THREADS`
    do
        export JULIA_NUM_THREADS=$NUM_THREADS;
        TIME=`julia diffusion_parallel_test.jl $NUM_CONVERGENCE_IT $NUM_MESH_NODES`
        echo $NUM_THREADS,$TIME >> diffusion_parallel_test_julia.dat

        export OMP_NUM_THREADS=$NUM_THREADS;
        TIME=`./diffusion_parallel_test $NUM_CONVERGENCE_IT $NUM_MESH_NODES`
        echo $NUM_THREADS,$TIME >> diffusion_parallel_test_c.dat
    done
done

# Plot results
julia plot_time_and_speedup.jl


