function calc_CP_forFSM(fname::String,pts::Matrix{Float64},outf::String,
                height_cutoff::Float64,can_local::Float64,can_stand::Float64)

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
    f = open(outdat,"a")
        writedlm(f,hcat(pts_x,pts_y,cc5,cc50,mCH5,mCH50))
    close(f)


end
