using .Threads

################################################################################
#   In this simple code a 2D stationary diffusion equation is solved using
#   the finite difference method
#
#   Equation: d2u/x2 + d2u/y2 = 0
#
#   Initial condition: u(t=0,x,y) = 0
#            
#   Boundary conditions:
#           u(t,x=0,y) = 0
#           u(t,x=1,y) = 0
#           u(t,x,y=0) = 1
#           u(t,x,y=1) = 0
#
#   How to run:
#           export JULIA_NUM_THREADS=4;
#           julia diffusion_parallel_test.jl
#
################################################################################


function solve_diff!(u,n,it_max)
    for k = 1:it_max
        @threads for j = 2:n-1
            for i = 2:n-1
                u[i,j] = (u[i+1,j]+u[i-1,j]+u[i,j+1]+u[i,j-1])/4.0
            end
        end
    end
end

# No. of convergence iterations
it_max = 100

# No. of spatial domain nodes
n = 2500

# Set initial conditions
u = zeros(n,n)

# Add boundary conditions
u[1,:] = ones(n)

# Solve eq. system, measuring time
t = @elapsed solve_diff!(u,n,it_max)

println(t)

#using Plots
#heatmap(u)
#savefig("test.png")
