using jl_cockpit
using Test

@testset "jl_cockpit.jl" begin
    #include("util_test.jl")
    @testset "plots" begin
        include("plots_test.jl")
    end

    @testset "training_loop" begin
        include("training_loop_test.jl")
    end
end

