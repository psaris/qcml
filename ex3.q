\l funq.q

-1 "loading data set";
X:(400#"F";",")0:`:ex3dataX.txt / 5000 20x20 bitmaps
y:first Y:(1#"F";",")0:`:ex3datay.txt  / integers 1-10 (10=0)

plt:.util.plot[20;10;.util.c16;avg] .util.hmap 20 cut
-1 "plotting 4 random bitmaps";
-1 value (,') over  plt each flip X[;-4?til count X 0];

lbls:"f"$1+til 10
lambda2:1
THETA:(1;1+count X)#0f

/ two ways to compute THETA (fmincg;.qml.minx)

-1 "using fmincg";
mf:(first .fmincg.fmincg[20;;THETA 0]::) / pass min func projection as parameter
cgf:.ml.rlogcostgrad[0;lambda2;X] / cost gradient function

/ -1 "using .qml.minx";
/ mf:{first .qml.minx[`quiet`full`iter,20;x;THETA]`last}
/ cgf:.ml.rlogcostgradf[lambda;X]

-1 "train one set of parameters for each number";
THETA:.ml.onevsall[mf;cgf;Y;lbls]
100*avg y=lbls .ml.predictonevsall[X] enlist THETA / what percent did we get correct?
-1 "showing a few mistakes";
w:-4?where not y=p:lbls .ml.predictonevsall[X] enlist THETA / what percent did we get correct?
-1 value (,') over plt each flip X[;w];
show flip([]p;y) w

-1 "showing the confusion matrix";
show .ml.cm[y;p]
