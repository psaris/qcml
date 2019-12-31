\l funq.q

-1 "loading data set";
X:(400#"F";",")0:`:ex3dataX.txt / 5000 20x20 bitmaps
y:first Y:(1#"H";",")0:`:ex3datay.txt  / integers 1-10 (10=0)

plt:value .util.plot[20;10;.util.c16;avg] .util.hmap 20 cut
-1 "plotting 4 random bitmaps";
-1 (,'/) plt each X@\:/:-4?til count X 0;

lbls:"h"$1+til 10
rf:.ml.l2[1]
THETA:(1;1+count X)#0f

/ two ways to compute THETA (fmincg;.qml.minx)

-1 "using fmincg";
f:first .fmincg.fmincg[20;;THETA 0] .ml.logcostgrad[rf;;X]@

/ -1 "using .qml.minx";
/ mf:{first .qml.minx[`quiet`full`iter,20;x;THETA]`last}
/ cgf:.ml.rlogcostgradf[lambda;X]

-1 "train one set of parameters for each number";
THETA:.ml.fitova[f;Y;lbls]
100*avg y=lbls .ml.clfova .ml.logpredict[X] THETA / what percent did we get correct?
-1 "showing a few mistakes";
w:-4?where not y=p:lbls .ml.clfova .ml.logpredict[X] THETA / what percent did we get correct?
-1 (,'/) plt each X@\:/:w;
show flip([]p;y) w

-1 "showing the confusion matrix";
show .util.cm[y;p]
