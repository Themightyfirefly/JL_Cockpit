using GLMakie

struct datapoint
    epoch::Int
    batch::Int
    loss
    grads
end

# Extending the function push! to ensure the Observable is triggered
#
# Observables are triggered when they get assigned a value,
# but when appending the list is mutated, not assigned, and therefore the Observable must be triggered manually
import Base.push!

"""
This function updates list of Observables with specific value of FLoat32
"""
function push!(list_obs::Observable{Vector{Float32}}, value::Float32)
    push!(list_obs[], value)
    list_obs[] = list_obs[]
end

"""
This function updates Observable with datapoint
"""
function push!(obs::Observable{Vector{datapoint}}, dp::datapoint)
    push!(obs[], dp)
    obs[] = obs[]
end
