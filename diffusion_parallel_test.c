#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

/*******************************************************************************
*   In this simple code a 2D stationary diffusion equation is solved using
*   the finite difference method
*
*   Equation: d2u/x2 + d2u/y2 = 0
*
*   Initial condition: u(t=0,x,y) = 0
*
*   Boundary conditions:
*           u(t,x=0,y) = 0
*           u(t,x=1,y) = 0
*           u(t,x,y=0) = 1
*           u(t,x,y=1) = 0
*
*   How to run:
*            export OMP_NUM_THREADS=4;
*            gcc -o diffusion_parallel_test -fopenmp diffusion_parallel_test.c
*            ./diffusion_parallel_test
*
*******************************************************************************/

int main() 
{
    // No. of convergence iterations
    int it_max = 100;

    // No. of spatial domain nodes
    int n = 2500;
    
    // Define dependent variable (e.g. Temperature)
    double * u = malloc(n*n*sizeof(double));

    // Set initial conditions
    for(int i=0;i<n*n;i++)
        u[i] = 0.0;

    // Add boundary conditions
    for(int j=0;j<n;j++)
        u[j] = 1.0;

    // Solve eq. system, measuring time
    double start, end;

    start = omp_get_wtime(); 

    for(int k=0;k<it_max;k++)
        #pragma omp parallel for collapse(2) schedule(guided)
        for(int i=1;i<n-1;i++)
            for(int j=1;j<n-1;j++)
                u[i*n+j] = (u[(i+1)*n+j]+u[(i-1)*n+j]+u[i*n+j+1]+u[i*n+j-1])/4.0;

    end = omp_get_wtime(); 

    // Print result
    printf("%f\n",end - start);

    free(u);
    return 0;
}
