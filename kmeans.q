\d .ml

edist:{sum x*x-:y}              / euclidian distance
mdist:{sum abs x-y}             / manhattan distance (taxicab metric)
hmean:{1f%avg 1f%x}             / harmonic mean
wmin:first iasc@

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid
cgroup:{[df;X;C] group wmin each flip df[X] each flip C}

/ k-(means|medians) algorithm

/ stuart lloyd's algorithm. using a (d)istance (f)ucntion and
/ (m)ean/edian (f)unction, find (k)-centroids in the data (X) starting
/ with a (C)entroid list. if C is an atom, use it to randomly
/ initialize C. if negative, use "Forgy" method and randomly pick k
/ centroids.  if positive, use "Random Partition" method to randomly
/ assign to k clusters.
lloyd:{[df;mf;X;C]
 if[0h>type C;if[0>C;C:X@\:C?count X 0]];
 g:$[0h>type C;group count[X 0]?C;cgroup[df;X;C]]; / assignment step
 C:mf''[X@\:value g];                              / update step
 C}

kmeans:lloyd[edist;avg]
kmedians:lloyd[mdist;med]
khmeans:lloyd[edist;hmean]

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

.ml.kmeans[X]\[-4]
.ml.kmedians[X]\[-4]
.ml.khmeans[X]\[4]

X:(x;y;z)
(.ml.ecdist[X] .ml.kmeans[X]@) each 1+til count X 0
(.ml.distortion .ml.ecdist[X] .ml.kmeans[X]@) each 1+til count X 0

\l /Users/nick/q/ml/plot.q
plt:.plot.plot[49;25;1_.plot.c10]
plt (x;y;z)
plt .ml.kmeans[(x;y;z)] 3
