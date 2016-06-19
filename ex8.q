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
 f:r*p*1+b*b;
 f%:r+p*b*b;
 f}
F1:F[1]

/ returns a number between 0 and 1 which indicates the similarity
/ between two datasets
jaccard:{x[0]%sum x _ 1}

/ Fowlkes–Mallows index (E. B. Fowlkes & C. L. Mallows 1983)
/ geometric mean of precision and recall
FW:{
 p:x[0]%sum x 0 2; / precision
 r:x[0]%sum x 0 3; / recall
 f:sqrt p*r;
 f}

nrng:{[n;s;e]s+til[1+n]*(e-s)%n}  / divide range (s;e) into n buckets

maxf:{[f;n;yval;pval]
 v:nrng[n;min pval;max pval];
 m:v .ml.imax f each v;
 m}

loadmovies:{
 `Y set (943#"F";",")0:`:Y.csv;
 `R set (943#"B";",")0:`:R.csv;
 `X set (10#"F";",")0:`:ex8_movies.csv;
 `THETA set (10#"F";",")0:`:Theta.csv;
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

loadmovies[]

/ average rating for first movie (toy story):
avg Y[0]where R 0

/ visualize dataset
plt:.plot.plot[79;40;.plot.c68]
reverse plt .plot.hmap Y

/ reduce the data set size so that this runs faster
nu:4;nm:5;nf:3                  / n users, n movies, n features
X:X[til nf;til nm]
THETA:THETA[til nf;til nu]
Y:Y[til nu;til nm]
R:R[til nu;til nm]

31.344056244274213~.ml.rcfcost[1.5;X;Y;R;THETA]
show each .ml.rcfcost[1.5;X;Y;R;THETA]
show each .ml.rcfgrad[1.5;X;Y;R;THETA]
show each .ml.rcfcostgrad[5;X;Y;R;THETA]
/ movie names
m:" " sv' 1_'" " vs' read0 `:movie_ids.txt
r:count[m]#0 / initial ratings
r[-1+1 98 7 12 54 64 66 69 183 226 355]:4 2 3 5 4 5 3 5 4 5 5
r[-1+426]:5
{where[0<x]#x}(m!r) / my ratings

loadmovies[]
Y,:r
R,:r>0
nu:count Y 0;nm:count Y;nf:10   / n users, n movies, n features
X:-2+nu?/:nf#4f
THETA:-2+nm?/:nf#4f
(X;THETA) ~ (nf;0N)#/:(0;nf*nu) _ xtheta:2 raze/ (X;THETA)


xtheta:first .fmincg.fmincg[100;.ml.rcfcostgrad[10f;Y;R;(nu;nf)];xtheta]
XTHETA:(nf;0N)#/:(0;nf*nu) _ xtheta
p:flip[XTHETA 1]$XTHETA 0
mp:last[p]+sum[Y*R]%sum R / add bias and save my predictions
`score xdesc ([]movie:m;score:mp)
