\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
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

R:(953#"B";",")0:`:R.csv
Y:(953#"I";",")0:`:Y.csv

/ average rating for first movie (toy story):
avg Y[0]where R 0

/ visualize dataset
plt:.plot.plot[79;40;.plot.c68]
reverse plt .plot.hmap Y
X:(953#"B";",")0:`:ex8_movieParams.csv