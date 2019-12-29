\l funq.q

\c 30 100

maxf:{[f;n;yval;pval]
 v:.util.nrng[n;min pval;max pval];
 m:v .ml.imax f each v;
 m}

/ missing Y values (specified in R) are converted from 0 to 0N so
/ there is no further need use R
loadmovies:{
 -1 "loading movie rating data";
 Y:(943#"F";",")0:`:ex8_Y.txt;
 -1 "loading unrated flags";
 `Y set Y+0N 0 (943#"B";",")0:`:ex8_R.txt;
 -1 "loading movie database";
 `X set (10#"F";",")0:`:ex8_movies.txt;
 -1 "loading user preferences";
 `THETA set (10#"F";",")0:`:ex8_theta.txt;
 }

plt:.util.plot[39;20;.util.c16;avg]
-1 "loading data set";
X:(2#"F";",")0:`:ex8data1.txt
-1 "loading validation data set";
Xval:(2#"F";",")0:`:ex8_Xval1.txt
yval:first (1#"F";",")0:`:ex8_yval1.txt
-1 "plotting data set";
plt X
mu:avg each X
sigma:var each X
-1 "computing probability values come from (mu;sigma) distribution";
p:.ml.gaussmvl[mu;sigma] X
plt X,enlist p
pval:.ml.gaussmvl[mu;sigma] Xval
-1 "plot relationship between cutoff and F1";
f:.ml.F1 . .ml.tptnfpfn[yval]pval<
plt (e;f each e:1_.util.nrng[1000;min pval;max pval])
-1 "finding optimal cutoff";
f 0N!e:.qml.min[1f%f@;med pval]
-1 "plotting outliers";
plt X,enlist p<e

-1 "loading multi dimensional data set";
X:(11#"F";",")0:`:ex8data2.txt
-1 "loading multi dimensional validation data set";
Xval:(11#"F";",")0:`:ex8_Xval2.txt
yval:first (1#"F";",")0:`:ex8_yval2.txt
mu:avg each X
sigma:var each X
-1 "computing probability values come from (mu;sigma) distribution";
p:.ml.gaussmvl[mu;sigma] X
pval:.ml.gaussmvl[mu;sigma] Xval
-1 "plot relationship between cutoff and F1";
f:.ml.F1 . .ml.tptnfpfn[yval]pval<
plt (e;f each e:1_.util.nrng[1000;min pval;max pval])
-1 "finding optimal cutoff";
f 0N!e:.qml.min[1f%f@;med pval]
f 0N!e:maxf[f;1000;yval;pval]
-1 "confirming 117 outliers";
.util.assert[117i] sum p<e
-1 "plotting outliers";
plt X[8+0 1],enlist p<e

/ recommender system

loadmovies[]             / X, Y, THETA
-1 "average rating for first movie (toy story):";
avg Y 0      

plt:.util.plot[80;40;.util.c10;avg]
-1  "visualizing dataset";
-1 value reverse plt .util.hmap Y;

-1 "reduce the data set size so that this runs faster";
n:(ni:5;nu:4);nf:3              / n items, n users, n features
X:X[til nf;til ni]
THETA:THETA[til nf;til nu]
Y:Y[til nu;til ni]
-1 "confirming regularized collaborative filtering cost";
.util.assert[22.224603725685668] count[Y 0]*.ml.cfcost[();Y;X;THETA]
.util.assert[31.344056244274213] count[Y 0]*.ml.cfcost[.ml.l2[1.5];Y;X;THETA]

.util.assert[(X;THETA)] .ml.cfcut[n] xtheta:2 raze/ (X;THETA)

-1 "checking collaborative filtering gradient computation";
.util.assert . .util.rnd[1e-6] .ml.checkcfgrad[1e-4;.ml.l2[1.5];n]

-1 "showing gradients";
show each .ml.cfgrad[.ml.l2[1.5];Y;X;THETA]
show each .ml.cfcut[n] last .ml.cfcostgrad[.ml.l2[1.5];n;Y;2 raze/ (X;THETA)]
-1 "loading movie names";
m:" " sv' 1_'" " vs' read0 `:movie_ids.txt
-1 "creating my own ratings";
r:count[m]#0n
r[-1+1 98 7 12 54 64 66 69 183 226 355]:4 2 3 5 4 5 3 5 4 5 5f
show {where[0<x]#x}(m!r)

loadmovies[]
-1 "joining my ratings to original data set";
Y,:r
n:(ni:count Y 0;nu:count Y);nf:10   / n items, n users, n features
-1 "randomly initializing theta";
xtheta:2 raze/ (X:-1+ni?/:nf#2f;THETA:-1+nu?/:nf#2f)

-1 "computing avg rating per movie";
a:.ml.navg Y
-1 "learning theta and x values from demeaned data";
xtheta:first .fmincg.fmincg[100;.ml.cfcostgrad[.ml.l2[1f];n;Y-\:a];xtheta]
-1 "predicting ratings";
p:.ml.cfpredict . XTHETA: .ml.cfcut[n] xtheta
-1 "adding mean back to predictions and store my predictions";
mp:last[p]+a
-1 "display sorted predictions";
show `score xdesc ([]movie:m;rating:r;score:mp)

-1 "showing best movies for each learned factor";
show m idesc each XTHETA[0]+\:a
-1 "showing worst movies for each learned factor";
show m iasc each XTHETA[0]+\:a
