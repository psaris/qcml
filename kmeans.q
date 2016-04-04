\d .ml

edist:{[X;c] sum X*X-:c} / euclidian distance
mdist:{[X;c] sum abs X-:c} / manhattan distance

cgroup:{[df;X;C] group (first iasc@) each flip df[X] each flip C}

k:{[df;mf;k;X;C]
 if[not count C;C:X@\:neg[k]?count first X];
 C:mf''[X@\:value cgroup[df;X;C]];
 C}

kmeans:k[edist;avg]
kmedians:k[mdist;med]

cdist:{[df;X;C] k!df[X@\:value g] C@\:k:key g:cgroup[df;X;C]}
ecdist:cdist[edist]
mcdist:cdist[mdist]

distortion:{[df;X;C] avg sum each d*d:value cdist[df;X;C]}
edistortion:distortion[edist]
mdistortion:distortion[mdist]


\

x:1 1 2 9 14 11 100 101 102 100
y:2 3 3 9 10 12 110 102 100 110
z:3 1 4 11 09 10 108 105 103 108
X:(x;y;z)
C:()

show flip C:kmedians[4;X]/[()]

X:(x;y;z)
(')[ecdist[X];kmeans[;X;()]] each 1+til count X 0
(')[edistortion[X];kmeans[;X;()]] each 1+til count X 0

iris:flip `slength`swidth`plength`pwidth`species!("FFFFS";",")0:`:/Users/nick/q/bezdekIris.data
X:iris c:`slength`swidth`plength`pwidth

\ts:1000 cdist[d] kmeans[3;d:flip 4#/:iris]/[()]
flip kmeans[3;X]/[()]
\l /Users/nick/q/ml/plot.q
plt:.plot.plot[74;24] ".-+*#@"
plt X

plt (x;y;z)
plt kmeans[3;(x;y;z)]/[()]

9612 8864