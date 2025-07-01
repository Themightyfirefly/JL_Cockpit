using jl_cockpit
using Test
include("../src/util.jl")

#function push!(list_obs::Observable{Vector{T}}, value::T) where {T<:Real}
@testset "push! with Real" begin
    obs = Observable([1.0, 2.0])
    push!(obs, 3.0)
    @test obs[] == [1.0, 2.0, 3.0]
    
    push!(obs, 4.5)
    @test obs[] == [1.0, 2.0, 3.0, 4.5]
    
    # Test with integers
    obs_int = Observable([1, 2])
    push!(obs_int, 7)
    @test obs_int[] == [1, 2, 7]
end