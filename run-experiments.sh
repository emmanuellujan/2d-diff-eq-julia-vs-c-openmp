#!/bin/sh

# Experiment parameters
export NUM_MAX_THREADS=8
export NUM_MEASUREMENTS=10 #30
export NUM_MAX_CONV_IT=100 #100000
export NUM_MESH_NODES=6500000 #4000000

# Clear data files and compile C code
rm -rf *.dat *.png
gcc -o diffusion_parallel_test -fopenmp diffusion_parallel_test.c -lm

# Run experiments
echo "No. threads,Time" >> diffusion_parallel_test_julia.dat
echo "No. threads,Time" >> diffusion_parallel_test_c.dat

for I in `seq 1 $NUM_MEASUREMENTS`;
do
    for NUM_THREADS in `seq 1 $NUM_MAX_THREADS`
    do
        export JULIA_NUM_THREADS=$NUM_THREADS;
        TIME=`julia diffusion_parallel_test.jl $NUM_MAX_CONV_IT $NUM_MESH_NODES`
        echo $NUM_THREADS,$TIME >> diffusion_parallel_test_julia.dat

        export OMP_NUM_THREADS=$NUM_THREADS;
        TIME=`./diffusion_parallel_test $NUM_MAX_CONV_IT $NUM_MESH_NODES`
        echo $NUM_THREADS,$TIME >> diffusion_parallel_test_c.dat
    done
done

# Plot results
julia plot_time_and_speedup.jl


