\l funq.q

plt:.util.plot[50;20;.util.c16]
-1 "loading data set";
X:(2#"F";",")0:`:ex7data2.txt
-1 "plotting data set";
plt X
C:flip (3 3;6 2;8 5)

-1 "confirming closest centroids";
.util.assert[(0 2 1!1#'0 1 2)] .ml.cgroup[.ml.edist;3#'X;C]
-1 "new centroids after one iteration of k-means";
.ml.kmeans[X;C]

-1 "new centroids after ten iteration of k-means";
10 .ml.kmeans[X]\C

/ 128x128 r g b (24 bit = 3*8 bits)
/ 128*128*24 = 393,216
-1 "loading rgb of bird_small";
X:(3#"F";",")0:`:bird_small.txt

-1 "converting to grayscale and plotting";
-1 value .util.plot[128;64;.util.c68] .util.hmap 128 cut .util.grayscale X;

-1 "mapping each color to 4 bits";
C:10 .ml.kmeans[X]/-16?/:X
-1 "compressing data by genrating groups";
/ 16*24+128*128*4 = 65,920
g:.ml.cgroup[.ml.edist;X;C]

-1 "recovering original image by ungrouping";
Xr:C@\:.ml.ugrp g

-1 "plotting reconstructed image";
-1 value .util.plot[128;64;.util.c16] .util.hmap 128 cut .util.grayscale Xr;

-1 "loading pca data set";
X:("FF";",") 0:`:ex7_pca.txt
-1 "plotting pca data set";
-1 value plt X;
-1 "projecting data onto single dimension";
-1 value plt .ml.project[1#.ml.pca Xn] Xn:.ml.zscore each X;

-1 "loading faces data";
X:(1024#"F";",") 0:`:ex7faces.txt
\c 50 200
plt:.util.plot[32;16;.util.c10] .util.hmap 32 cut
-1 "visualing faces";
-1 value plt X[;i:rand 5000];
-1 value plt X[;i];
-1 value (,') over plt each flip X[;-4?5000];

-1 "performing pca on z-scored data";
v:.ml.pca Xn:.ml.zscore each X
-1 "plotting first two pca faces";
-1 value (,') over plt each 2#v;
-1 "recovering initial faces by using 100 components";
-1 value plt .ml.project[100#v;Xn][;0];
-1 value plt X[;0];
