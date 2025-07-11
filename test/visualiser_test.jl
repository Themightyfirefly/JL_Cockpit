using JL_Cockpit
using Test
using GLMakie: Observable, Figure

@testset "iterate_plot_pos" begin
    # a == b -> (1, b+1)
    @test JL_Cockpit.iterate_plot_pos(1, 1) == (1, 2)

    # a+1 == b -> (a+1, 1)
    @test JL_Cockpit.iterate_plot_pos(1, 2) == (2, 1)

    # a > b -> (a, b+1)
    @test JL_Cockpit.iterate_plot_pos(3, 2) == (3, 3)

    # a < b -> (a+1, b)
    @test JL_Cockpit.iterate_plot_pos(2, 5) == (3, 5)
end


@testset "visualiser" begin
    vis = JL_Cockpit.visualiser(
        vis_loss       = false,
        vis_grad_norm  = false,
        vis_hist_1d    = false,
        vis_params     = false,
        vis_distance   = false,
        vis_update_size= false,
        vis_hist_2d    = false
    )

    # check if they have the same type
    @test isa(vis, JL_Cockpit.Visualiser)

    # datapoints should be an Observable with empty vector
    @test isa(vis.datapoints, Observable{Vector{JL_Cockpit.Datapoint}})
    @test vis.datapoints[] == Vector{JL_Cockpit.Datapoint}()
end