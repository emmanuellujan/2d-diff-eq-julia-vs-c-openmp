using .Threads

################################################################################
#   In this simple code a 2D stationary diffusion equation is solved using
#   the finite difference method
#
#   Equation: d2u/dx2 + d2u/dy2 = 0
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
#           export JULIA_NUM_THREADS=8;
#           julia diffusion_parallel_test.jl 100000 4000000
#
#           Note: first parameter is the number of convergence iterations
#                 second parameter is the number of mesh nodes
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
it_max = parse(Int,ARGS[1])

# No. of spatial domain nodes
n = floor(Int,sqrt(parse(Int,ARGS[2])))

# Set initial conditions
u = zeros(n,n)

# Add boundary conditions
u[1,:] = ones(n)

# Solve eq. system, measuring time
t = @elapsed solve_diff!(u,n,it_max)

println(t)

filename = "diffusion-on-a-plate.png"
if !isfile(filename)
    using Plots
    heatmap(u)
    savefig(filename)
end

