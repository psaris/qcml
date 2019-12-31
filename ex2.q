\l funq.q

\c 50 100
-1 "plot sigmoid function";
-1 value .util.plt .ml.sigmoid .1*-50+til 100;
-1 "loading data set";
data:("FFF";",")0:`:ex2data1.txt
show .util.plt data
X:2#data
Y:-1#data
THETA:(1;1+count X)#0f
-1 "computing logistic regression cost";
.ml.logcost[();Y;X;THETA]
-1 "computing logistic regression gradient";
.ml.loggrad[();Y;X;THETA]

/ rk:runge–kutta, slp: success linear programming
opts:`quiet`rk`iter,7000
THETA:(1;1+count X)#0f
-1 "finding function minimum";
.qml.minx[opts;.ml.logcost[();Y;X]enlist::;THETA]
-1 "use gradient to improve efficiency";
.qml.minx[opts;.ml.logcostgradf[();Y;X];THETA]

THETA:.qml.minx[opts;.ml.logcost[();Y;X]enlist::;THETA]
-1 "compring plots";
-1 "raw data";
show .util.plt data
-1 "fitted data";
show .util.plt X,.ml.logpredict[X] THETA

