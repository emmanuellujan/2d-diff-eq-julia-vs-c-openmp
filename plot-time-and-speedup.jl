using CSV, DataFrames, Statistics, Plots

# Read CSV files
data_julia = CSV.read("diffusion-parallel-julia.csv")
data_c = CSV.read("diffusion-parallel-c.csv")
mean_julia = aggregate(data_julia, "No. threads", mean)
mean_c = aggregate(data_c, "No. threads", mean)
std_julia = aggregate(data_julia, "No. threads", std)
std_c = aggregate(data_c, "No. threads", std)

line_width = 2

# Plot experiment time with respects to no. of threads
plot(mean_julia[1],mean_julia[2],color="blue",lw=line_width,yerror=std_julia[2],label ="Time in Julia using Threads")
plot!(mean_c[1],mean_c[2],color="red",lw=line_width,yerror=std_c[2],label = "Time in C using OpenMP")
ylabel!("Time \\ s")
xlabel!("No. of threads")
savefig("diffusion-parallel-julia-vs-c-time.svg")

# Plot experiment speedup with respect to no. of threads
plot(mean_julia[1],mean_julia[2][1]./mean_julia[2],color="blue",lw=line_width,yerror=std_julia[2],label ="Speedup in Julia using Threads")
plot!(mean_c[1],mean_c[2][1]./mean_c[2],color="red",lw=line_width,yerror=std_c[2],label = "Speedup in C using OpenMP")
plot!(legend=:topleft)
ylabel!("Speedup")
xlabel!("No. of threads")
savefig("diffusion-parallel-julia-vs-c-speedup.svg")

