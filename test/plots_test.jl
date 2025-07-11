using Test
using jl_cockpit
using GLMakie

fig = Figure(size = (1920, 1080))
datapoints = Observable{Vector{Datapoint}}([])

@testset "loss_plot" begin
    datapoints[] = []
    plot_data = loss_plot!(fig, datapoints)

    push!(datapoints, Datapoint(0, 0, 1.0, nothing, nothing))
    @test plot_data[] == []

    push!(datapoints, Datapoint(0, 0, 2.0, nothing, nothing))
    @test plot_data[] == Float32[2.0]
    
    push!(datapoints, Datapoint(0, 0, 0.2, nothing, nothing))
    @test plot_data[] == Float32[2.0, 0.2]

    push!(datapoints, Datapoint(0, 0, 1, nothing, nothing))
    @test plot_data[] == Float32[2.0, 0.2, 1.0]
end

@testset "grad_norm_plot" begin
    datapoints[] = []
    plot_data = grad_norm_plot!(fig, datapoints)

    push!(datapoints, Datapoint(0, 0, nothing, nothing, nothing))
    @test plot_data[] == []
end

@testset "hist_1d_plot" begin
    datapoints[] = []
    plot_data = hist_1d_plot!(fig, datapoints)

    push!(datapoints, Datapoint(0, 0, nothing, nothing, nothing))
    @test plot_data[] == []
end