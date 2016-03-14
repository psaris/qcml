\d .plot
scale:{floor (y-1e-10)*0^x%max x-:min x} / scale x to [0,y)
nrng:{[n;s;e]s+til[1+n]*(e-s)%n}         / divide range (s;e) into n buckets
/ cut nxn matrix into (x;y;z) for use by plot
hmap:{(flip i cross reverse i:til count x ),enlist raze x}
/ plot X using (c)haracters limited to (w)idth and (h)eight
/ X can be x, (x;y) or (x;y;z)
plot:{[w;h;c;X]
 cn:count c,:();                  / allow a single character
 if[0h<type X;X:(til count X;X)]; / turn x into (x;y)
 if[3>n:count X;X,:count[X 0]#1]; / turn (x;y) into (x;y;z)
 w&:count distinct X 0;           / compute width
 h&:count distinct X 1;           / compute height
 Z:@[X;0 1;scale;(w;h)];          / scale (x;y) to (w;h)
 Z:flip key[Z],'sum each value Z:Z[2]g:group flip 2#Z; / sum overlapping z
 Z:@[Z;2;scale;cn];                                    / scale z
 p:h#enlist w#" ";                                     / empty canvas
 p:.[;;:;]/[p;flip Z 1 0;c Z 2];                       / plot points
 k:nrng[h-1] . (min;max)@\:X 1;                        / compute key
 p:reverse k!p;                                        / generate plot
 p}
c:".-+*#@"                      / default character set
plt:plot[50;24;c]               / default plot function

\
\c 50 100
.plot.plt 100?1f
.plot.plt sin .001*til 10000
.plot.plt (log 100000?1f;100000?1f)
.plot.plt .plot.hmap flip 10 cut til 100
.plot.plot[50;24;" ",.plot.c] (x;y;(y:100000?1f)+x:100000?1f)

\cd /Users/nick/Documents/qtips/
\l /Users/nick/Documents/qtips/qtips.q
.plot.plt (tm;px:100*.sim.path[.2;.02] tm:.util.rng[1;2000.01.01;2001.01.01]%365.25)


