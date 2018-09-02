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
 -1 "loading initial theta value";
 `THETA set (10#"F";",")0:`:ex8_theta.txt;
 }

plt:.util.plot[39;20;.util.c16]
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
plt (e;f each e:.util.nrng[1000;min pval;max pval])
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
plt (e;f each e:.util.nrng[1000;min pval;max pval])
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

plt:.util.plot[80;40;.util.c10]
-1  "visualizing dataset";
-1 value reverse plt .util.hmap Y;

-1 "reduce the data set size so that this runs faster";
n:(nu:4;nf:3);nm:5              / n users, n features, n movies
THETA:THETA[til nf;til nu]
X:X[til nf;til nm]
Y:Y[til nu;til nm]
-1 "confirming regularized collaborative filtering cost";
.util.assert[22.224603725685668] .ml.rcfcost[0;Y;THETA;X]
.util.assert[31.344056244274213] .ml.rcfcost[1.5;Y;THETA;X]

.util.assert[(THETA;X)] .ml.cfcut[n] thetax:2 raze/ (THETA;X)

-1 "checking collaborative filtering gradient computation";
.ml.checkcfgradients[0f;n]
.ml.checkcfgradients[1.5;n]

-1 "showing gradients";
show each .ml.rcfgrad[1.5;Y;THETA;X]
show each  .ml.cfcut[n] last .ml.rcfcostgrad[1.5;Y;n;2 raze/ (THETA;X)]
-1 "loading movie names";
m:" " sv' 1_'" " vs' read0 `:movie_ids.txt
-1 "creating my own ratings";
r:count[m]#0n
r[-1+1 98 7 12 54 64 66 69 183 226 355]:4 2 3 5 4 5 3 5 4 5 5f
show {where[0<x]#x}(m!r)

loadmovies[]
-1 "joining my ratings to original data set";
Y,:r
nu:count Y;nm:count Y 0;nf:10   / n users, n movies, n features
n:(nu;nf);
-1 "randomly initializing theta";
thetax:2 raze/ (THETA:-1+nu?/:nf#2f;X:-1+nm?/:nf#2f)

-1 "computing avg rating per movie";
a:.ml.f2nd[avg] Y
-1 "learning theta and x values from demeaned data";
thetax:first .fmincg.fmincg[100;.ml.rcfcostgrad[1f;Y-\:a;n];thetax]
-1 "predicting ratings";
p:.ml.mtm . THETAX: .ml.cfcut[n] thetax
-1 "adding mean back to predictions and store my predictions";
mp:last[p]+a
-1 "display sorted predictions";
show `score xdesc ([]movie:m;rating:r;score:mp)

-1 "showing best movies for each learned factor";
show m idesc each THETAX[1]+\:a
-1 "showing worst movies for each learned factor";
show m iasc each THETAX[1]+\:a
