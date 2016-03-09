
x:1 1 2 9 14 11 100 101 102 100
y:2 3 3 9 10 12 110 102 100 110
z:3 1 4 11 09 10 108 105 103 108
X:(x;y;z)
C:()

dist:{[X;c] sum X*X-:c}

cgroup:{[X;C] group (first iasc@) each flip dist[X] each flip C}

kmeans:{[n;X;C]
 if[not count C;C:X@\:neg[n]?count first X];
 C:avg''[X@\:value cgroup[X;C]];
 C}

cdist:{[X;C] k!dist[X@\:value g] C@\:k:key g:cgroup[X;C]}

distortion:{[X;C] avg sum each d*d:value cdist[X;C]}

\

show C:kmeans[4;X]/[()]

X:(x;y;z)
(')[cdist[X];kmeans[;X;()]] each 1+til count X 0
(')[distortion[X];kmeans[;X;()]] each 1+til count X 0

iris:flip `slength`swidth`plength`pwidth`species!("FFFFS";",")0:`:/Users/nick/q/bezdekIris.data
X:iris c:`slength`swidth`plength`pwidth

\ts:1000 cdist[d] kmeans[3;d:flip 4#/:iris]/[()]
flip kmeans[3;X]/[()]
\l /Users/nick/q/ml/plot.q
plt:.plot.plot[74;24] ".-+*#@"
plt X

9612 8864