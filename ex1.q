\l funq.q

\c 100 100
-1 "loading data set 1";
data:("FF";",")0:`:ex1data1.txt
show .util.plt data
X:1#data
Y:-1#data
THETA:(1;1+count X)#0f          / initial guess
alpha:.001                      / learning rate
-1 "confirming accurate least squares cost";
.util.assert[32.072733877455654] .ml.lincost[X;Y;THETA]
-1 "plot cost function of each gd step";
show .util.plt .ml.lincost[X;Y] each 20 .ml.gd[alpha;.ml.lingrad[X;Y]]\THETA
-1 "obtain optimal theta";
.ml.gd[alpha;.ml.lingrad[X;Y]]/[THETA]
-1 "plot prediction of optimal theta";
show .util.plt X,.ml.gd[alpha;.ml.lingrad[X;Y]]/[THETA]$.ml.prepend[1f] X
-1 "qml least squares";
flip .qml.mlsq[flip .ml.prepend[1f] X;flip Y]
-1 "normal equations";
.ml.mlsq[Y;.ml.prepend[1f] X]
-1 "q least squares";
Y lsq .ml.prepend[1f] X

-1 "loading data set 2";
data:("FFF";",")0:`:ex1data2.txt
show .util.plt data
X:2#data
-1 "normalizing (zscoring) data";
X:.ml.zscore each X
Y:-1#data
alpha:.01
THETA:(1;1+count X)#0f
-1 "performing gradient descent";
4000 .ml.gd[alpha;.ml.lingrad[X;Y]]/ THETA

-1 "comparing with qml least squares";
flip .qml.mlsq[flip .ml.prepend[1f] X;flip Y]
-1 "comparing with unflipped version";
.qml.mlsqx[`flip;.ml.prepend[1f] X;Y]
-1 "comparing with normal equations";
.ml.mlsq[Y;.ml.prepend[1f] X]
-1 "comparing with q least squares";
Y lsq .ml.prepend[1f] X
