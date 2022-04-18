# load the terra package
library(terra)

# set working directory
setwd("Z:/students/ggrossman/")

# read a raster from file
p <- rast("Z:/students/ggrossman/data/rs_data/20190706_002918_101b_3B_AnalyticMS_SR.tif")

# plot the raster
plot(p)

# plot an rgb rendering of the data
plotRGB(p, r=3, g=2, b=1)

# plot an rgb rendering of the data
plotRGB(p, r=3, g=2, b=1,
        scale=65535,
        stretch="hist")

# read data file with field observations of canopy cover
tree <- read.csv("Z:/data/rs_data/siberia_stand_data.csv", header = T)

# convert to vector object using terra package
gtree <- vect(tree, geom=c("Long", "Lat"), "epsg:4326")

# project the data to match the coordinate system of the raster layer
# ext() min and max long and lat
gtree2 <- project(gtree, p)

# create a polygon from the extent of the points
b <- as.lines(ext(gtree), "epsg:4326")

# reproject the polygons to the same projection as our raster
b2 <- project(b, crs(p))

# buffer the extent by 200m
b3 <- buffer(b2, width = 200)

# use this to crop the raster layer so we
p2 <- crop(p, b3, filename = "20190706_SR_crop.tif", overwrite=TRUE)

# plot an rgb rendering of the data
plotRGB(p2, r=3, g=2, b=1,
        scale=65535,
        stretch="lin")

# calculate NDVI
ndvi <- (p2[[4]]-p2[[3]])/(p2[[4]]+p2[[3]])

names(ndvi) <- "ndvi"

# create a plot of the ndvi map with sample points on top
png(filename = "ndvi_map.png",
    width = 6, height = 4, units = "in", res = 300)

plot(ndvi)

points(gtree2, cex = gtree$cc.pct/50, col = "blue")

dev.off()

# extract NDVI values for each point
nt <- terra::extract(ndvi, gtree2, fun = mean, method = 'bilinear')

# plot ndvi vs. canopy cover
plot(nt$ndvi, gtree2$cc.pct,
     pch = 16, col = "blue", xlim = c(0,1))
