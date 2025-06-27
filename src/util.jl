using GLMakie: Observable

struct Datapoint
    epoch::Int
    batch::Int
    loss::Float32
    grads #TODO define the type!
end

# Extending the function push! to ensure the Observable is triggered
#
# Observables are triggered when they get assigned a value,
# but when appending the list is mutated, not assigned, and therefore the Observable must be triggered manually
import Base.push!

"""
This function updates list of Observables with specific value of FLoat32
"""
function push!(list_obs::Observable{Vector{T}}, value::T) where {T<:Real}
    push!(list_obs[], value)
    list_obs[] = list_obs[]
end

"""
This function updates Observable with datapoint
"""
function push!(obs::Observable{Vector{Datapoint}}, dp::Datapoint)
    push!(obs[], dp)
    obs[] = obs[]
end
