\d .ml

edist:{[X;c] sum X*X-:c} / euclidian distance
mdist:{[X;c] sum abs X-:c} / manhattan distance (taxicab metric)

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid
cgroup:{[df;X;C] group (first iasc@) each flip df[X] each flip C}

/ k-(means|medians) algorithm

/ using a (d)istance (f)ucntion and (m)ean/edian (f)unction, find
/ (k)-centroids in the data (X) starting with a (potentially empty)
/ (C)entroid list
k:{[df;mf;k;X;C]
 if[not count C;C:X@\:neg[k]?count first X];
 C:mf''[X@\:value cgroup[df;X;C]];
 C}

kmeans:k[edist;avg]
kmedians:k[mdist;med]

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid and return the distance
cdist:{[df;X;C] k!df[X@\:value g] C@\:k:key g:cgroup[df;X;C]}
ecdist:cdist[edist]
mcdist:cdist[mdist]

/ using the (d)istance (f)unction, computer the total distortion (or
/ distance) of data (X) when clustered to the nearest (C)entroid
distortion:{[df;X;C] sum sum each value cdist[df;X;C]}
edistortion:distortion[edist]
mdistortion:distortion[mdist]


\

x:1 1 2 9 14 11 100 101 102 100
y:2 3 3 9 10 12 110 102 100 110
z:3 1 4 11 09 10 108 105 103 108
X:(x;y;z)
C:()

show flip C:.ml.kmedians[4;X]/[()]

X:(x;y;z)
(')[.ml.ecdist[X];.ml.kmeans[;X;()]] each 1+til count X 0
(')[.ml.edistortion[X];.ml.kmeans[;X;()]] each 1+til count X 0

\l /Users/nick/q/ml/plot.q
plt:.plot.plot[49;25;1_.plot.c10]
plt (x;y;z)
plt .ml.kmeans[3;(x;y;z)]/[()]

/ get http data from (h)ost with (l)ocaction
hget:{[h;l] (`$":http://",h)"GET ",l," HTTP/1.1\r\nHost:",h,"\r\n\r\n"}

/ classic machine learning iris data
s:hget["scipy-cookbook.readthedocs.io";"/_downloads/bezdekIris.data.txt"]
iris:flip `slength`swidth`plength`pwidth`species!("FFFFS";",") 0: -1_last "\r\n" vs s
X:value flip 4#/:iris
plt X 3
flip .ml.kmeans[3;X]/[()]

.ml.ecdist[X] .ml.kmeans[3;X]/[()]
