\l /Users/nick/q/funq/plot.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q

\
\c 100 100
\cd /Users/nick/Downloads/machine-learning-ex1/ex1
data:("FF";",")0:`:ex1data1.txt
.plot.plt data
X:1#data
Y:-1#data
THETA:(1;1+count X)#0f          / initial guess
alpha:.001                      / learning rate
32.072733877455654 ~ .ml.lincost[X;Y;THETA]   / least squares cost
/ plot cost function of each gd step
.plot.plt .ml.lincost[X;Y] each 20 .ml.gd[alpha;.ml.lingrad[X;Y]]\THETA
.ml.gd[alpha;.ml.lingrad[X;Y]]/[THETA] / obtain optimal theta
/ plot prediction of optimal theta
.plot.plt X,.ml.gd[alpha;.ml.lingrad[X;Y]]/[THETA]$.ml.addint X
flip .qml.mlsq[flip .ml.addint X;flip Y] / qml least squares
.ml.mlsq[Y;.ml.addint X]                 / normal equations
Y lsq .ml.addint X                       / q least squares

data:("FFF";",")0:`ex1data2.txt
.plot.plt 2#data
X:data 0 1
X:.ml.zscore each X             / normalize and
Y:-1#data
alpha:.01
THETA:(1;1+count X)#0f
4000 .ml.gd[alpha;.ml.lingrad[X;Y]]/ THETA

flip .qml.mlsq[flip .ml.addint X;flip Y] / qml least squares
.qml.mlsqx[`flip;.ml.addint X;Y]         / flipped
.ml.mlsq[Y;.ml.addint X]                 / normal equations
Y lsq .ml.addint X                       / q least squares
