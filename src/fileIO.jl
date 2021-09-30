function createfiles_calcCP(outdir::String,outstr::String,pts::Array{Float64,2})

        outfile  = joinpath(outdir,"Output_"*outstr*".nc")

        ds = NCDataset(outfile,"c",format=:netcdf4_classic)

        defDim(ds,"Coordinates",size(pts,1))
        defVar(ds,"easting",pts[:,1],("Coordinates",))
        defVar(ds,"northing",pts[:,2],("Coordinates",))

        cc5   = defVar(ds,"CanopyCover_5m",Int32,("Coordinates",),deflatelevel=5,attrib=["scale_factor"=>0.01,])
        cc50  = defVar(ds,"CanopyCover_50m",Int32,("Coordinates",),deflatelevel=5,attrib=["scale_factor"=>0.01,])
        mCH5  = defVar(ds,"MeanCanopyHeight_5m",Int32,("Coordinates",),deflatelevel=5,attrib=["scale_factor"=>0.01,])
        mCH50 = defVar(ds,"MeanCanopyHeight_50m",Int32,("Coordinates",),deflatelevel=5,attrib=["scale_factor"=>0.01,])

        return cc5,cc50,mCH5,mCH50, ds

end
