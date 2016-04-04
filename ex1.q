\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/qml/src/qml.q

\
\c 100 100
\cd /Users/nick/Downloads/machine-learning-ex1/ex1
data:("FF";",")0:`:ex1data1.txt
.plot.plt data
X:1#data
y:-1#data
theta:(1;1+count X)#0f          / initial guess
alpha:.001                      / learning rate
32.072733877455654 ~ .ml.lincost[X;y;enlist theta]   / least squares cost
/ plot cost function of each gd step
.plot.plt raze (.ml.lincost[X;y]enlist@) each 20 .ml.gd[alpha;X;y]\theta
.ml.gd[alph;X;y]/[theta]       / obtain optimal theta
/ plot prediction of optimal theta
.plot.plt X,gd[alpha;X;y]/[theta]$.ml.addint X
flip .qml.mlsq[flip .ml.addint X;flip y] / qml least squares
flip solve[.ml.addint X;y]               / normal equations
y lsq .ml.addint X                       / q least squares

data:("FFF";",")0:`ex1data2.txt
.plot.plt 2#data
X:data 0 1
X:.ml.zscore each X                 / normalize and
y:-1#data
alpha:.01
theta:enlist (1+count X)#0f
4000 .ml.gd[alpha;X;y]/ theta

flip .qml.mlsq[flip .ml.addint X;flip y] / qml least squares
flip solve[.ml.addint X;y]               / normal equations
y lsq .ml.addint X                       / q least squares
