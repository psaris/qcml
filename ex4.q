\l funq.q

-1 "using random values to check neural network gradient calculation";
hgflf:`.ml.sigmoid`.ml.dsigmoid`.ml.sigmoid`.ml.xentropy
.ml.checknngradients[0;.1f;3 5 3;hgflf]

-1 "loading data set";
X:(400#"F";",")0:`:ex4dataX.txt
y:first (1#"F";",")0:`:ex4datay.txt
THETA1:flip (401#"F";",") 0:`:ex4theta1.txt
THETA2:flip (26#"F";",") 0:`:ex4theta2.txt

-1 "using loaded THETA values to predict y";
.ml.predict/[X;(THETA1;THETA2)]
Y:.ml.diag[10#1f]@\:"i"$y-1
-1 "confirming logistic cost calculations with and without regularization";
n:400 25 10
theta:2 raze/ (THETA1;THETA2)
.util.assert[0.28762916516131876] first .ml.nncostgrad[0f;0f;n;hgflf;X;Y] theta
.util.assert[0.38376985909092381] first .ml.nncostgrad[0f;1f;n;hgflf;X;Y] theta
.util.assert[0.026047433852894011] sum last .ml.nncostgrad[0f;0f;n;hgflf;X;Y] theta
.util.assert[0.0099559365856808548] sum last .ml.nncostgrad[0f;1f;n;hgflf;X;Y] theta

Y:.ml.diag[last[n]#1f]@\:"i"$y-1
-1 "computing the sum of each gradient";
sum each sum each g:.ml.nncut[n] last .ml.nncostgrad[0f;1f;n;hgflf;X;Y;theta]

THETA:2 raze/ .ml.glorotu'[1_n;1+-1_n];
-1 "optimizing THETA";
.fmincg.fmincg[50;.ml.nncostgrad[0f;0f;n;hgflf;X;Y];THETA]
-1 "computing the cost and gradient of given THETA values";
.ml.nncostgrad[0f;0f;n;hgflf;X;Y;2 raze/ (THETA1;THETA2)]

-1 "re-initializing THETA";
THETA:2 raze/ .ml.glorotu'[1_n;1+-1_n];
-1 "optimizing THETA";
THETA:first .fmincg.fmincg[50;.ml.nncostgrad[0f;0f;n;hgflf;X;Y];THETA]

-1 "using one vs all to predict y";
100*avg y=p:1+.ml.predictonevsall[X].ml.nncut[n] THETA
-1 "visualize hidden features";
plt:.util.plot[20;10;.util.c16] .util.hmap 20 cut
show plt 1_first THETA1

-1 "showing a few mistakes";
\c 100 200
w:-4?where not y=p:1f+.ml.predictonevsall[X].ml.nncut[n] THETA
-1 value (,') over plt each flip X[;w];
show flip([]p;y)w

-1 "showing the confusion matrix";
show .ml.cm[y;p]
