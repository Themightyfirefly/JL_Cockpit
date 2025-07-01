module jl_cockpit
    using GLMakie
    using LinearAlgebra
    using Zygote
    using Flux
    using MLDatasets
    using Statistics
 
    include("training_loop.jl")


    export visualiser

    export training_loop

end