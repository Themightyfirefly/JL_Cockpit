using JL_Cockpit
using Test

@testset "JL_Cockpit.jl" begin
    @testset "plots" begin
        include("plots_test.jl")
    end

    @testset "training_loop" begin
        include("training_loop_test.jl")
    end

    @testset "util" begin
        include("util_test.jl")
    end

    @testset "visualiser" begin
        include("visualiser_test.jl")
    end
end

