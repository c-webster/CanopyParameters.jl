function createfiles_calcCP(outdir::String,outstr::String,pts::Array{Float64,2})

        outfile  = joinpath(outdir,"Output_"*outstr*".nc")

        dataset = netcdf.Dataset(outfile,"w",format="NETCDF4_CLASSIC")

        locxy = dataset.createDimension("loc_XY",size(pts,1))
        ptsn  = dataset.createDimension("ptsn",2)

        cc5  = dataset.createVariable("cc5",np.float32,("loc_XY"),zlib="True",
                                            least_significant_digit=3)
        cc50      = dataset.createVariable("cc50",np.float32,("loc_XY"),zlib="True",
                                            least_significant_digit=3)

        mCH5  = dataset.createVariable("mCH5",np.float32,("loc_XY"),zlib="True",
                                            least_significant_digit=3)
        mCH50      = dataset.createVariable("mCH50",np.float32,("loc_XY"),zlib="True",
                                            least_significant_digit=3)

        Coors        = dataset.createVariable("Coordinates",np.float32,("loc_XY","ptsn"),zlib="TRUE",
                                            least_significant_digit=1)

        if size(pts,1) == 1
            Coors[1] = np.array(pts[1,1:2])
        else
            for cx in eachindex(pts[:,1])
             Coors[cx] = np.array(pts[cx,:])
            end
        end

        return cc5,cc50,mCH5,mCH50, dataset

end
