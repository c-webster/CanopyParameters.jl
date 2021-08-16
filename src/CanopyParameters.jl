module CanopyParameters

using SpatialFileIO, DelimitedFiles, Statistics

using Conda, PyCall

function __init__()
    @eval global netcdf    = pyimport("netCDF4")
    @eval global np        = pyimport("numpy")
end


include("calc_CP.jl")

export
    calc_CP_forFSM,
    calc_CanopyCover

end
