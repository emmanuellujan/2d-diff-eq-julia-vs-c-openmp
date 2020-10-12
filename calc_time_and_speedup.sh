#!/bin/sh

rm -rf *.dat

gcc -o diffusion_parallel_test -fopenmp diffusion_parallel_test.c

echo "No. threads,Time" >> diffusion_parallel_test_julia.dat
echo "No. threads,Time" >> diffusion_parallel_test_c.dat

for NUM_THREADS in `seq 1 8`
do
    TIME_MIN=100000
    export JULIA_NUM_THREADS=$NUM_THREADS;
    for I in `seq 1 10`;
    do    
        TIME=`julia diffusion_parallel_test.jl`
        lt=$(echo "$TIME < $TIME_MIN" | bc -q )
        if [ $lt = 1 ]; then
            TIME_MIN=$TIME
        fi
    done
    echo $NUM_THREADS,$TIME_MIN >> diffusion_parallel_test_julia.dat

    TIME_MIN=100000
    export OMP_NUM_THREADS=$NUM_THREADS;
    for I in `seq 1 10`;
    do    
        TIME=`./diffusion_parallel_test`
        lt=$(echo "$TIME < $TIME_MIN" | bc -q )
        if [ $lt = 1 ]; then
            TIME_MIN=$TIME
        fi
    done
    echo $NUM_THREADS,$TIME_MIN >> diffusion_parallel_test_c.dat
done

julia plot_time_and_speedup.jl


