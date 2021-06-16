function calc_CP_forFSM(fname::String,pts::Matrix{Float64},outf::String,
            can_local::Float64,can_stand::Float64,height_cutoff=2.0::Float64)

    pts_x = pts[:,1]
    pts_y = pts[:,2]

    # load the chm
    chm_x, chm_y, chm_z = read_ascii(fname,true,true); #vectorized

    chm_b = fill(NaN,size(chm_z))
    chm_b[chm_z .< height_cutoff] .= 0
    chm_b[chm_z .>= height_cutoff] .= 1

    chm_bool = Bool.(chm_b)

    cc5   = Vector{Float64}();
    cc50  = Vector{Float64}();
    mCH5  = Vector{Float64}();
    mCH50 = Vector{Float64}();

    for px in eachindex(pts_x)

        dist = hypot.(chm_x.-pts_x[px],chm_y.-pts_y[px])

        dx_local = dist .< can_local
        dx_stand = dist .< can_stand

        push!(cc5,mean(chm_b[dx_local]))
        push!(cc50,mean(chm_b[dx_stand]))

        push!(mCH5,mean(chm_z[dx_local .& chm_bool]))
        push!(mCH50,mean(chm_z[dx_stand .& chm_bool]))

    end

    header = ["easting" "northing" "CC5" "CC50" "mCH5" "mCH50"]

    open(outf;write=true) do f
        writedlm(f,header)
    end
    f = open(outf,"a")
        writedlm(f,hcat(pts_x,pts_y,cc5,cc50,mCH5,mCH50))
    close(f)


end

function calc_CanopyCover(fname::String,pts::Matrix{Float64},outf::String,
                height_cutoff=2::Float64,can_local::Float64,can_stand::Float64)


    pts_x = pts[:,1]
    pts_y = pts[:,2]

    # load the chm
    chm_x, chm_y, chm_z = read_ascii(fname,true,true); #vectorized

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
