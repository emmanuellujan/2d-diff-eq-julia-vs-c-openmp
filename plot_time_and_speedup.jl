using CSV, Plots
data_julia = CSV.read("diffusion_parallel_test_julia.dat")
data_c = CSV.read("diffusion_parallel_test_c.dat")

plot(data_julia[1],data_julia[2],color="blue",lw=3,label ="Time in Julia with Threads")
scatter!(data_julia[1],data_julia[2],color="blue",label ="")
plot!(data_c[1],data_c[2],color="red",lw=3,label = "Time in C with OpenMP")
scatter!(data_c[1],data_c[2],color="red",label ="")
#plot!(legend=:bottomleft)
ylabel!("Time \\ s")
xlabel!("No. of threads")
savefig("diffusion_parallel_julia-vs-c_time.svg")

plot(data_julia[1],data_julia[1]./data_julia[2],color="blue",lw=3,label ="Speedup in Julia with Threads")
scatter!(data_julia[1],data_julia[1]./data_julia[2],color="blue",label ="")
plot!(data_c[1],data_c[1]./data_c[2],color="red",lw=3,label = "Speedup in C with OpenMP")
scatter!(data_c[1],data_c[1]./data_c[2],color="red",label ="")
plot!(legend=:topleft)
ylabel!("Speedup")
xlabel!("No. of threads")
savefig("diffusion_parallel_julia-vs-c_speedup.svg")

