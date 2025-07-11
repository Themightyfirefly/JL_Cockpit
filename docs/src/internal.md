```@meta
CurrentModule = jl_cockpit
```
```@index
Pages   = ["internal.md"]
```




```@docs
preprocess(dataset)
```



```@docs
iterate_plot_pos(a::Int64, b::Int64)
```




```@docs
push!(list_obs::Observable{Vector{T}}, value::T) where {T<:Real}
```

```@docs
push!(obs::Observable{Vector{Datapoint}}, dp::Datapoint)
```

```@docs
append!(obs::Observable{Vector{T}}, val_vector::Vector{T}) where {T<:Real}
```