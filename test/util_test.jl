using jl_cockpit
using Test
using GLMakie: Observable
using Zygote

#function push!(list_obs::Observable{Vector{T}}, value::T) where {T<:Real}
@testset "push_Real" begin
    # Test with Float64
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

# function push!(obs::Observable{Vector{Datapoint}}, dp::Datapoint)

# struct Datapoint
#     epoch::Int
#     batch::Int
#     loss::Union{Float32, Nothing}
#     grads::Union{@NamedTuple{Any}, Nothing}
#     params::Zygote.Params{Zygote.Buffer{Any, Vector{Any}}}
# end
@testset "push_Datapoint" begin
    grads = (Any = 1.23,)

    buf = Zygote.Buffer(Any[1.0, 2.0])
    param_array = Any[buf]
    params = Zygote.Params(param_array)

    dp1 = jl_cockpit.Datapoint(1, 1, 0.5f0, grads, params)
    dp2 = jl_cockpit.Datapoint(1, 2, 0.3f0, nothing, params)
    obs = Observable([dp1])

    push!(obs, dp2)

    @test obs[] == [dp1, dp2]
end


# function append!(obs::Observable{Vector{T}}, val_vector::Vector{T}) where {T<:Real}
@testset "append" begin
    # Test with Floats
    obs = Observable([1.0, 2.0])
    append!(obs, [3.0, 4.5])
    @test obs[] == [1.0, 2.0, 3.0, 4.5]

    # Test with Integers
    obs_int = Observable([1, 2])
    append!(obs_int, [7, 8, 9])
    @test obs_int[] == [1, 2, 7, 8, 9]

    # Append empty vector should remain unchanged
    obs_empty = Observable([5.0])
    append!(obs_empty, Float64[])
    @test obs_empty[] == [5.0]
end


@testset "myflatten" begin
    # myflatten!(res, t::Union{Tuple, NamedTuple}) -> nothing
    # 1) Tuple
    res1 = Float32[]
    jl_cockpit.myflatten!(res1, (1.0, 2.0))
    @test res1 == Float32[]

    # 2) NamedTuple
    res2 = Float32[]
    jl_cockpit.myflatten!(res2, (; a = 3.0, b = 4.5))
    @test res2 == Float32[]

    # 3) myflatten!(res, t::Zygote.Params{Zygote.Buffer{Any, Vector{Any}}})  -> nothing
    buf = Zygote.Buffer(Any[9.9, 10.10])
    ps  = Zygote.Params(Any[buf])
    res3 = Float32[]
    jl_cockpit.myflatten!(res3, ps)
    @test res3 == Float32[]

    # 4) myflatten!(res, xs::AbstractArray) empty array -> append
    arr  = [7.7, 8.8]
    res4 = Float32[]
    jl_cockpit.myflatten!(res4, arr)
    @test res4 == append!(res4, arr)

    # 5) myflatten!(res, xs::AbstractArray) -> append
    arr  = [7.7, 8.8]
    res5 = Float32[1.1, 6.6]
    jl_cockpit.myflatten!(res5, arr)
    @test res5 == append!(res5, arr)

    # myflatten!(res, x) -> nothing
    # 6) Scalar value
    res6 = Float32[]
    jl_cockpit.myflatten!(res6, 42.0)
    @test res6 == Float32[]

    # 7) 'nothing'
    res7 = Float32[1.1]
    jl_cockpit.myflatten!(res7, nothing)
    @test res7 == Float32[1.1]
end