\l /Users/nick/q/funq/plot.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q
\l /Users/nick/q/funq/qmlmm.q

/TODO: get more efficient method
covm:{(1%count x 0)*x$/:\:x}
/cvm:{(x+flip(not n=\:n)*x:(n#'0.0),'(x$/:'(n:til count x)_\:x)%count first x)-a*\:a:avg each x}

pca:{[k;X]
 Xn:.ml.zscore each X;
 v:last .qml.mev covm Xn;
 Z:(k#v)$Xn; / project onto k dimensions
 Xr:flip[k#v]$Z; /reconstruct initial image
 (v;Z;Xr)}


\
\cd /Users/nick/Downloads/machine-learning-ex7/ex7
plt:.plot.plot[50;20;1_.plot.c16]
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

/ convert RBG -> Gray Scale
/ https://en.wikipedia.org/wiki/Grayscale
r2g:0.2989 0.5870 0.1140
.plot.plot[255;128;.plot.c68] .plot.hmap 128 cut r2g$X

/ map to 4 bits
C:10 .ml.kmeans[X]/16
/ compress information
/ 16*24+128*128*4 = 65,920
g:.ml.cgroup[.ml.edist;X;C]

/ recover image
/ TODO: can we get an operator that returns key/value as a pair
\ts:10 Xr:C@\:{x[0] iasc x 1} flip raze flip each flip (key g;value g)
/\ts:10 C@\:last each asc raze value[g](,\:)'key g
/TODO: group stocks (generated with qtips) into sectors

/ plot reconstructed image
a:.plot.plot[255;128;.plot.c16] .plot.hmap 128 cut r2g$Xr

X:("FF";",") 0:`:ex7_pca.csv
-1 value plt X;
r:`v`Z`Xr!pca[1] X
/ recover initial data
-1 value plt r`Xr;

/ faces
X:(1024#"F";",") 0:`:ex7faces.csv
/ visualize faces
\c 50 200
plt:.plot.plot[63;32;.plot.c10] .plot.hmap 32 cut
-1 value plt X[;i:rand 5000];
-1 value plt X[;i];
-1 value (,') over plt each flip X[;-4?5000];

r:`v`Z`Xr!pca[100] X
/ pca faces
(,') over plt each 2# r[`v]
/ recover initial faces
-1 value plt r[`Xr][;0];
-1 value plt X[;0];
