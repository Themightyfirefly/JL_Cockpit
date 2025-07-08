using jl_cockpit
using Test

@testset "jl_cockpit.jl" begin
    @testset "plots" begin
        include("plots_test.jl")
    end

    @testset "training_loop" begin
        include("training_loop_test.jl")
    end

    @testset "util" begin
        include("util_test.jl")
    end
end

