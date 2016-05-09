\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

\
.ml.checknngradients[.1f;3 5 3]

\cd /Users/nick/Downloads/machine-learning-ex4/ex4
X:(400#"F";",")0:`:ex4data1.csv
y:first (1#"F";",")0:`:ex4data2.csv
theta1:flip (401#"F";",") 0:`:theta1.csv
theta2:flip (26#"F";",") 0:`:theta2.csv

.ml.predict/[X;(theta1;theta2)]
ymat:.ml.diag[10#1f]@\:"i"$y-1
0.28762916516131876 = .ml.rlogcost[0f;X;ymat] (theta1;theta2)
0.38376985909092381 = .ml.rlogcost[1f;X;ymat] (theta1;theta2)
0.026047433852894011 = sum 2 raze/ .ml.rloggrad[0f;X;ymat] (theta1;theta2)
0.0099559365856808548 = sum 2 raze/ .ml.rloggrad[1f;X;ymat] (theta1;theta2)

n:400 25 10;
ymat:.ml.diag[last[n]#1f]@\:"i"$y-1
\ts sum each   sum each g:.ml.mcut[n] last .ml.nncost[X;ymat;1f;n;2 raze/ (theta1;theta2)]
theta:2 raze/ .ml.rweights'[-1_n;1_n];
.fmincg.fmincg[50;.ml.nncost[X;ymat;0f;n];theta]
.ml.nncost[X;ymat;0f;n;2 raze/ (theta1;theta2)]

theta:2 raze/ .ml.rweights'[-1_n;1_n];
theta:2 raze/ (theta1;theta2)
theta:first .fmincg.fmincg[50;.ml.nncost[X;ymat;0;n];theta]

100*avg y=1+.ml.predictonevsall[X].ml.mcut[n] theta
/ visualize hidden features
plt:.plot.plot[39;20;.plot.c16] .plot.hmap 20 cut
plt 1_first theta1

/ mistakes
\c 100 200
w:-4?where not y=p:1+.ml.predictonevsall[X].ml.mcut[n] theta
(,') over plt each flip X[;w]
flip([]p;y)w
