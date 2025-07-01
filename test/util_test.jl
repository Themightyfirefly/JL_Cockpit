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

#function push!(obs::Observable{Vector{Datapoint}}, dp::Datapoint)
# struct Datapoint
#     epoch::Int
#     batch::Int
#     loss::Union{Float32, Nothing}
#     grads::Union{@NamedTuple{Any}, Nothing}
#     params::Zygote.Params{Zygote.Buffer{Any, Vector{Any}}}
# end
# @testset "push! with Datapoint" begin
#     buffer = Zygote.Buffer([1.0, 2.0])
#     params = Zygote.Params([buffer])
#     grads = (; g1=1.0, g2=2.0)
    
#     dp1 = Datapoint(1, 1, 0.5f0, grads, params)
#     dp2 = Datapoint(1, 2, 0.3f0, nothing, params)
    
#     obs = Observable([dp1])
#     push!(obs, dp2)
#     @test obs[] == [dp1, dp2]
# end

@testset "append!" begin
    
end