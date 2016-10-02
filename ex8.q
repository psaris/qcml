\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

\c 30 100

/ given expected boolean values x and observered value y, return
/ tp,tn,fp,fn
tptnfpfn:{(x;nx;x;nx:not x){sum x*y}'(y;ny;ny:not y;y)}

/ aka rand measure (William M. Rand 1971)
accuracy:{sum[x 0 1]%sum x}

/ f measure: given (b)eta and x:tptnfpfn
/ harmonic mean of precision and recall
F:{[b;x]
 p:x[0]%sum x 0 2; / precision
 r:x[0]%sum x 0 3; / recall
 f:r*p*1+b2:b*b;
 f%:r+p*b2;
 f}
F1:F[1]

/ returns a number between 0 and 1 which indicates the similarity
/ between two datasets
jaccard:{x[0]%sum x _ 1}

/ Fowlkes–Mallows index (E. B. Fowlkes & C. L. Mallows 1983)
/ geometric mean of precision and recall
FM:{x[0]%sqrt sum[x 0 2]*sum x 0 3}

/ Matthews Correlation Coefficient
/ geometric mean of the regression coefficients of the problem and its dual
/ -1 0 1 (none right, same as random prediction, all right)
MCC:{ ((-). x[0 2]*x 1 3)%sqrt prd x[0 0 1 1]+x 2 3 2 3}

nrng:{[n;s;e]s+til[1+n]*(e-s)%n}  / divide range (s;e) into n buckets

maxf:{[f;n;yval;pval]
 v:nrng[n;min pval;max pval];
 m:v .ml.imax f each v;
 m}

/ missing Y values (specified in R) are converted from 0 to 0N so
/ there is no further need use R
loadmovies:{
 Y:(943#"F";",")0:`:Y.csv;
 `Y set Y+0N 0 (943#"B";",")0:`:R.csv;
 `X set (10#"F";",")0:`:ex8_movies.csv;
 `THETA set flip (10#"F";",")0:`:Theta.csv;
 }
\
\cd /Users/nick/Downloads/machine-learning-ex8/ex8
plt:.plot.plot[39;20;1_.plot.c16]
X:(2#"F";",")0:`:ex8data1.csv
Xval:(2#"F";",")0:`Xval1.csv
yval:first (1#"F";",")0:`yval1.csv
plt X
mu:avg each X
s2:var each X
p:.ml.gaussmv[mu;s2] X
plt X,enlist p
pval:.ml.gaussmv[mu;s2] Xval
/ plot relationship between cutoff and F1
f:F1 tptnfpfn[yval]pval<
plt (e;f each e:nrng[1000;min pval;max pval])
/ find optimal cutoff
f 0N!e:.qml.min[1f%f@;med pval]
/ plot outliers
plt X,enlist p<e

/ multi dimensional
X:(11#"F";",")0:`:ex8data2.csv
Xval:(11#"F";",")0:`Xval2.csv
yval:first (1#"F";",")0:`yval2.csv
mu:avg each X
s2:var each X
p:.ml.gaussmv[mu;s2] X
pval:.ml.gaussmv[mu;s2] Xval
/ plot relationship between cutoff and F1
f:F1 tptnfpfn[yval]pval<
plt (e;f each e:nrng[1000;min pval;max pval])
/ find optimal cutoff
f 0N!e:.qml.min[1f%f@;med pval]
f 0N!e:maxf[f;1000;yval;pval]
/ count outliers
117i~sum p<e
/ plot outliers
plt X[8+0 1],enlist p<e

/ recommender system

loadmovies[]             / X, Y, THETA
avg Y 0                  / average rating for first movie (toy story):

/ visualize dataset
plt:.plot.plot[79;40;.plot.c68]
reverse plt .plot.hmap Y

/ reduce the data set size so that this runs faster
n:(nu:4;nf:3;nm:5)              / n users, n features, n movies
THETA:THETA[til nu;til nf]
X:X[til nf;til nm]
Y:Y[til nu;til nm]
22.224603725685668~.ml.rcfcost[0;Y;THETA;X]
31.344056244274213~.ml.rcfcost[1.5;Y;THETA;X]

(THETA;X) ~ .ml.cfcut[n] thetax:2 raze/ (THETA;X)

.ml.checkcfgradients[0f;n]
.ml.checkcfgradients[1.5;n]

show each .ml.rcfgrad[1.5;Y;THETA;X]
show each  .ml.cfcut[n] last .ml.rcfcostgrad[1.5;Y;n;2 raze/ (THETA;X)]
/ movie names
m:" " sv' 1_'" " vs' read0 `:movie_ids.txt
r:count[m]#0n                   / initial ratings
r[-1+1 98 7 12 54 64 66 69 183 226 355]:4 2 3 5 4 5 3 5 4 5 5f
{where[0<x]#x}(m!r)             / my ratings

loadmovies[]
Y,:r
n:(nu:count Y;nf:10;nm:count Y 0)   / n users, n features, movies
thetax:2 raze/ (THETA:-1+nf?/:nu#2f;X:-1+nm?/:nf#2f)

a:avg each flip Y / average per movie
thetax:first .fmincg.fmincg[100;.ml.rcfcostgrad[10f;Y-\:a;n];thetax] / learn
p:($) . THETAX: .ml.cfcut[n] thetax / predictions
mp:last[p]+a                      / add bias and save my predictions
`score xdesc ([]movie:m;rating:r;score:mp) / display sorted predictions

m (5#idesc@) each THETAX[1]+\:a
m (-5#idesc@) each THETAX[1]+\:a
