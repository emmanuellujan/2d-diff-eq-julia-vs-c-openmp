using CSV, DataFrames, Plots

# Read CSV files
heatmap_julia = Matrix(CSV.read("heatmap-julia.csv",datarow=1))
heatmap_c = Matrix(CSV.read("heatmap-c.csv",datarow=1))

# Plot heatmaps
heatmap(heatmap_julia)
savefig("heatmap-julia.png")
heatmap(heatmap_c)
savefig("heatmap-c.png")
heatmap(heatmap_julia-heatmap_c)
savefig("heatmap-diff.png")





