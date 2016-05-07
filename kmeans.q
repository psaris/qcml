\d .ml

edist:{[X;c] sum X*X-:c} / euclidian distance
mdist:{[X;c] sum abs X-:c} / manhattan distance (taxicab metric)

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid
cgroup:{[df;X;C] group (first iasc@) each flip df[X] each flip C}

/ k-(means|medians) algorithm

/ using a (d)istance (f)ucntion and (m)ean/edian (f)unction, find
/ (k)-centroids in the data (X) starting with a (C)entroid list
/ if C is an atom, use it to initialize C with random elements
k:{[df;mf;X;C]
 if[0h>type C;C:X@\:neg[C]?count X 0];
 C:mf''[X@\:value cgroup[df;X;C]];
 C}

kmeans:k[edist;avg]
kmedians:k[mdist;med]

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid and return the distance
cdist:{[df;X;C] k!df[X@\:value g] C@\:k:key g:cgroup[df;X;C]}
ecdist:cdist[edist]
mcdist:cdist[mdist]

distortion:sum sum each

\

x:1 1 2 9 14 11 100 101 102 100
y:2 3 3 9 10 12 110 102 100 110
z:3 1 4 11 09 10 108 105 103 108
X:(x;y;z)
C:()

show flip C:.ml.kmedians[X]/[4]

X:(x;y;z)
(.ml.ecdist[X] .ml.kmeans[X]@) each 1+til count X 0
(.ml.distortion .ml.ecdist[X] .ml.kmeans[X]@) each 1+til count X 0

\l /Users/nick/q/ml/plot.q
plt:.plot.plot[49;25;1_.plot.c10]
plt (x;y;z)
plt .ml.kmeans[(x;y;z)] 3
