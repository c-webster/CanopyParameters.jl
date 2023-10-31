function calc_CP_forOSHD(chm_x::Vector{Float64},chm_y::Vector{Float64},chm_z::Vector{Float64},chm_la::Vector{Float64},
                            pts_x::Vector{Float64},pts_y::Vector{Float64},exdir::String,outstr::String)

    height_cutoff = 2.0
    can_local = 5.0
    can_stand = 50.0

    # create the output files
    cc5,cc50,mCH5,mCH50,mLA5,mLA50, dataset = createfiles_calcCP(exdir,outstr,hcat(pts_x,pts_y),true)

    chm_b = fill(0,size(chm_z))
    chm_b[chm_z .<= height_cutoff] .= 0
    chm_b[chm_z .> height_cutoff] .= 1

    chm_bool = Bool.(chm_b)

    for px in eachindex(pts_x)

        dist = hypot.(chm_x.-pts_x[px],chm_y.-pts_y[px])

        dx_local = dist .< can_local

        if sum(dx_local) > 0 && !isempty(chm_z[dx_local .& chm_bool])
            cc5[px]  = Int.(round.(mean(chm_b[dx_local]).*100))
            mCH5[px] = Int.(round.(mean(chm_z[dx_local .& chm_bool]).*100))
            mLA5[px] = Int.(round.(mean(chm_la[dx_local .& chm_bool]).*100))
        else
            cc5[px]  = 0
            mCH5[px] = 0
            mLA5[px] = 0
        end

        dx_stand = dist .< can_stand

        if sum(dx_stand) > 0 && !isempty(chm_z[dx_stand .& chm_bool])
            cc50[px]  = Int.(round.(mean(chm_b[dx_stand]).*100))
            mCH50[px] = Int.(round.(mean(chm_z[dx_stand .& chm_bool]).*100))
            mLA50[px] = Int.(round.(mean(chm_la[dx_stand .& chm_bool]).*100))
        else
            cc50[px] = 0
            mCH50[px] = 0
            mLA50[px] = 0
        end

    end

    close(dataset)

end


function calc_CP_forFSM(chm_x::Vector{Float64},chm_y::Vector{Float64},chm_z::Vector{Float64},
    pts_x::Vector{Float64},pts_y::Vector{Float64},exdir::String,outstr::String,height_cutoff=2::Number)

    can_local = 5.0
    can_stand = 50.0

    chm_b = fill(NaN,size(chm_z))
    chm_b[chm_z .< height_cutoff] .= 0
    chm_b[chm_z .>= height_cutoff] .= 1

    chm_bool = Bool.(chm_b)

    cc5,cc50,mCH5,mCH50, dataset = createfiles_calcCP(exdir,outstr,hcat(pts_x,pts_y),false)

    for px in eachindex(pts_x)

        dist = hypot.(chm_x.-pts_x[px],chm_y.-pts_y[px])

        dx_local = dist .< can_local

        if sum(dx_local) > 0 && !isempty(chm_z[dx_local .& chm_bool])
            cc5[px]  = Int.(round.(mean(chm_b[dx_local]).*100))
            mCH5[px] = Int.(round.(mean(chm_z[dx_local .& chm_bool]).*100))
        else
            cc5[px]  = 0
            mCH5[px] = 0
        end

        dx_stand = dist .< can_stand

        if sum(dx_stand) > 0 && !isempty(chm_z[dx_stand .& chm_bool])
            cc50[px]  = Int.(round.(mean(chm_b[dx_stand]).*100))
            mCH50[px] = Int.(round.(mean(chm_z[dx_stand .& chm_bool]).*100))
        else
            cc50[px] = 0
            mCH50[px] = 0
        end

    end

    close(dataset)




end



function calc_CanopyCover(fname::String,pts::Matrix{Float64},outf::String,
                can_local::Float64,can_stand::Float64,height_cutoff=2::Float64)


    pts_x = pts[:,1]
    pts_y = pts[:,2]

    # load the chm
    chm_x, chm_y, chm_z = read_griddata(fname,true,true); #vectorized

    chm_b = fill(NaN,size(chm_z))
    chm_b[chm_z .< height_cutoff] .= 0
    chm_b[chm_z .>= height_cutoff] .= 1

    chm_bool = Bool.(chm_b)

    cc5   = Vector{Float64}();
    cc10   = Vector{Float64}();
    cc20   = Vector{Float64}();
    cc30   = Vector{Float64}();
    cc40   = Vector{Float64}();
    cc50  = Vector{Float64}();


    for px in eachindex(pts_x)

        dist = hypot.(chm_x.-pts_x[px],chm_y.-pts_y[px])

        push!(cc5,mean(chm_b[dist .< 5]))
        push!(cc10,mean(chm_b[dist .< 10]))
        push!(cc20,mean(chm_b[dist .< 20]))
        push!(cc30,mean(chm_b[dist .< 30]))
        push!(cc40,mean(chm_b[dist .< 40]))
        push!(cc50,mean(chm_b[dist .< 50]))

    end

    header = ["easting" "northing" "CC5" "CC10" "CC20" "CC30" "CC40" "CC50"]

    open(outf;write=true) do f
        writedlm(f,header)
    end
    f = open(outf,"a")
        writedlm(f,hcat(pts_x,pts_y,cc5,cc10,cc20,cc30,cc40,cc50))
    close(f)

end
