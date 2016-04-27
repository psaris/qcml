\d .plot
scale:{y+(z-y)*x%max x-:min x}    / scale z to [x,y]
zscale:{floor scale[x;y-1e-10;z]} / zero scale x to [0,y)
nrng:{[n;s;e]s+til[1+n]*(e-s)%n}  / divide range (s;e) into n buckets
/ cut mxn matrix into (x;y;z) for use by plot
hmap:{(flip (til count x) cross reverse til count first x),enlist raze x}
/ plot X using (c)haracters limited to (w)idth and (h)eight
/ X can be x, (x;y) or (x;y;z)
plot:{[w;h;c;X]
 cn:count c,:();                  / allow a single character
 if[0h<type X;X:(til count X;X)]; / turn x into (x;y)
 if[3>n:count X;X,:count[X 0]#1]; / turn (x;y) into (x;y;z)
 Z:@[X;0 1;zscale;(w;h)];          / scale (x;y) to ([0;w);[0;h))
 Z:flip key[Z],'sum each value Z:Z[2]g:group flip 2#Z; / sum overlapping z
 Z:@[Z;2;zscale;cn];                                   / scale z
 p:h#enlist w#" ";                                     / empty canvas
 p:.[;;:;]/[p;flip Z 1 0;c Z 2];                       / plot points
 k:nrng[h-1] . (min;max)@\:X 1;                        / compute key
 p:reverse k!p;                                        / generate plot
 p}

c10:" .:-=+*#%@"          / http://paulbourke.net/dataformats/asciiart
c10:" .-:=+x#%@"          / 10 characters
c16:" .-:=+*xoXO#$&%@"    / 16 characters
c68:" .'`^,:;Il!i><~+_-?][}{1)(|/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$"
c89:" `-.'_:,=^;<+!*?/cLzrs7TivJtC{3F)Il(xZfY5S2eajo14[nuyE]P6V9kXpKwGhqAUbOd8#HRDB0$mgMW&Q%N@"
plt:plot[59;30;1_c16]               / default plot function

\
\c 50 100
plt:.plot.plot[20;10;1_.plot.c16]
plt til 12
.plot.plt sin .001*til 10000
.plot.plt (log 100000?1f;100000?1f)
.plot.plt .plot.hmap flip 10 cut til 100
.plot.plot[19;10;.plot.c89] (x;y;(y:100000?1f)+x:100000?1f)





\cd /Users/nick/Documents/qtips/
\l /Users/nick/Documents/qtips/qtips.q
.plot.plt (tm;px:100*.sim.path[.2;.02] tm:.util.rng[1;2000.01.01;2001.01.01]%365.25)
subset:{x .util.rng[1] . "i"$count[x]*((min;max)@\:"i"$z)%y}
s:("J"$" " vs) each 1_read0 `:/Users/nick/Documents/plot/nick.pgm
\c 500 500
s:reverse[s[0]] # raze 2_ s
plt:.plot.plot[99;50;.plot.c10]
plt:.plot.plot[99;50;.plot.c16]
plt:.plot.plot[59;30;.plot.c89]
plt:.plot.plot[59;30;subset[.plot.c89;255] raze s]
plt:.plot.plot[239;120;reverse .plot.c89]
value plt .plot.hmap flip s
