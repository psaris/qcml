\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/qml/src/qml.q

/ least squares cost function
lscost:{[X;y;theta](1f%2*count y 0)*y$/:y-:theta$X}
/ gradient descent
gd:{[X;y;alpha;theta] theta+(alpha%count y 0)*X$/:y-theta$X}
/ normal equations
solve:{[X;y]inv[X$/:X]$y$/:X}
/ feature normalization
zscore:{(x-avg x)%dev x}

\
\c 100 100
\cd /Users/nick/Downloads/machine-learning-ex1/ex1
data:("FF";",")0:`:ex1data1.txt
.plot.plt data
X:1#data
X:((1;count X 0)#1f),X          / add intercept
y:data 1#1
theta:enlist count[X]#0f        / initial guess
alpha:.001                      / learning rate
lscost[X;y;theta]               / least squares cost
/ plot cost function of each gd step
.plot.plt raze (sum lscost[X;y]@) each 20 gd[X;y;alpha]\theta
gd[X;y;alpha]/[theta]           / obtain optimal theta
/ plot prediction of optimal theta
.plot.plt X[1#1],gd[X;y;alpha]/[theta]$X
flip .qml.mlsq[flip X;flip y] / qml least squares
flip solve[X;y]               / normal equations
y lsq X                       / q least squares

data:("FFF";",")0:`ex1data2.txt
.plot.plt 2#data
X:data 0 1
X:zscore each X                 / normalize and
X:((1;count X 0)#1f),X          / add intercept
y:data 1#2
alpha:.01
theta:enlist count[X]#0f
4000 gd[X;y;alpha]/ theta

flip .qml.mlsq[flip X;flip y] / qml least squares
flip solve[X;y]               / normal equations
y lsq X                       / q least squares
