#!/bin/sh

# Experiment parameters
export NUM_THREADS=8 # Range to be evaluated: 1..NUM_THREADS
export NUM_MEASUREMENTS=10 # No. of measurements per each thread experiment
export NUM_CONVERGENCE_IT=100 # No. of convergence iterations
export NUM_MESH_NODES=6500000 # No. of mesh nodes

# Clear data files and compile C code
rm -rf *.csv *.png *.svg
gcc -o diffusion-parallel -fopenmp diffusion-parallel.c -lm

# Run experiments
echo "No. threads,Time" >> diffusion-parallel-julia.csv
echo "No. threads,Time" >> diffusion-parallel-c.csv

for I in `seq 1 $NUM_MEASUREMENTS`;
do
    for NUM_THREADS in `seq 1 $NUM_THREADS`
    do
        export JULIA_NUM_THREADS=$NUM_THREADS;
        TIME=`julia diffusion-parallel.jl $NUM_CONVERGENCE_IT $NUM_MESH_NODES`
        echo $NUM_THREADS,$TIME >> diffusion-parallel-julia.csv

        export OMP_NUM_THREADS=$NUM_THREADS;
        TIME=`./diffusion-parallel $NUM_CONVERGENCE_IT $NUM_MESH_NODES`
        echo $NUM_THREADS,$TIME >> diffusion-parallel-c.csv
    done
done

# Plot results
julia plot-time-and-speedup.jl
julia plot-heatmaps.jl


