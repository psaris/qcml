\l /Users/nick/q/funq/util.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q
\l /Users/nick/q/funq/qmlmm.q

\
\cd /Users/nick/Downloads/machine-learning-ex7/ex7
plt:.util.plot[50;20;.util.c16]
X:(2#"F";",")0:`:ex7data2.csv
plt X
C:flip (3 3;6 2;8 5)

/ closest centroids
(0 2 1!1#'0 1 2)~.ml.cgroup[.ml.edist;3#'X;C]
/ new centroids
.ml.kmeans[X;C]

/ 10 steps of k-means
10 .ml.kmeans[X]\C

/ 128x128 r g b (24 bit = 3*8 bits)
/ 128*128*24 = 393,216
X:(3#"F";",")0:`:bird_small.csv

show .util.plot[128;64;.util.c68] .util.hmap 128 cut .util.grayscale X

/ map to 4 bits
C:10 .ml.kmeans[X]/16
/ compress information
/ 16*24+128*128*4 = 65,920
g:.ml.cgroup[.ml.edist;X;C]

/ recover image
\ts:10 Xr:C@\:{x[0] iasc x 1} flip raze flip each flip (key g;value g)
/\ts:10 C@\:last each asc raze value[g](,\:)'key g

/ plot reconstructed image
show .util.plot[128;64;.util.c16] .util.hmap 128 cut .util.grayscale Xr;

X:("FF";",") 0:`:ex7_pca.csv
-1 value plt X;
/ project onto single dimension
-1 value plt .ml.project[1#.ml.pca Xn] Xn:.ml.zscore each X;

/ faces
X:(1024#"F";",") 0:`:ex7faces.csv
/ visualize faces
\c 50 200
plt:.util.plot[32;16;.util.c10] .util.hmap 32 cut
-1 value plt X[;i:rand 5000];
-1 value plt X[;i];
-1 value (,') over plt each flip X[;-4?5000];

v:.ml.pca Xn:.ml.zscore each X
/ pca faces
-1 value (,') over plt each 2#v;
/ recover initial faces
-1 value plt .ml.project[100#v;Xn][;0];
-1 value plt X[;0];
