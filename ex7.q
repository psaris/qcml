\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/ml/kmeans.q
\l /Users/nick/q/qml/src/qml.q

\
\cd /Users/nick/Downloads/machine-learning-ex7/ex7
plt:.plot.plot[50;20;.plot.c]
X:(2#"F";",")0:`:ex7data2.csv
plt X
C:flip (3 3;6 2;8 5)

/ closest centroids
(0 2 1!1#'0 1 2)~.ml.cgroup[.ml.edist;3#'X;C]
/ new centroids
.ml.kmeans[3;X;C]

/ 10 steps of k-means
10 .ml.kmeans[3;X]\C

/ 128x128 r g b (24 bit = 3*8 bits)
/ 128*128*24 = 393,216
X:(3#"F";",")0:`:bird_small.csv

/ map to 4 bits
C:10 .ml.kmeans[16;X]/()
/ compress information
/ 16*24+128*128*4 = 65,920
g:.ml.cgroup[.ml.edist;X;C]

/ recover image
/ TODO: can we get an operator that returns key/value as a pair
\ts:10 C@\:{x[0] iasc x 1} flip raze flip each flip (key g;value g)
/\ts:10 C@\:last each asc raze value[g](,\:)'key g
/TODO: group stocks (generated with qtips) into sectors

X:("FF";",") 0:`:ex7_pca.csv
plt X
r:`v`Z`Xr!.ml.pca[1] X
/ recover initial data
plt r`Xr

/ faces
X:(1024#"F";",") 0:`:ex7faces.csv
/ visualize faces
\c 50 200
plt:.plot.plot[32;32;" ",.plot.c] .plot.hmap 32 cut
(,') over plt each flip X[;-4?5000]

r:`v`Z`Xr!.ml.pca[100] X
/ pca faces
(,') over plt each r[`v][til 4]
/ recover initial faces
(,') over plt each flip r[`Xr][;til 4]
