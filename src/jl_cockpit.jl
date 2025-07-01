using GLMakie
using LinearAlgebra
using Zygote
using Flux
using MLDatasets
using Statistics

module jl_cockpit

    # plots.jl is used to define how each individual plot looks like
    #include("plots.jl")

    # Here the training loop is defined and executed. 
    include("training_loop.jl")

    # Used to store the observables and manages the visualisation
    #include("visualiser.jl")

    # Extra functions (mostly additions to general functions via multiple dispatch)
    #include("util.jl")

end