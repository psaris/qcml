\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/qml/src/qml.q

/ least squares cost function
lscost:{[X;y;theta](1f%2*count y)*y$y-:X$theta}
/ gradient descent
gd:{[X;y;alpha;theta] theta+(alpha%count y)*flip[X]$y-X$theta}
/ normal equations
solve:{[X;y]inv[fX$X]$(fX:flip X)$y}
/ feature normalization
zscore:{(x-avg x)%dev x}

\
\cd /Users/nick/Downloads/machine-learning-ex1/ex1
data:("FF";",")0:`:ex1data1.txt
.plot.plt data
X:1f,' flip 1#data              / add intercept
y:data 1
theta:count[first X]#0f         / initial guess
alpha:.001                      / learning rate
lscost[X;y;theta]               / least squares cost
/ plot cost function of each gd step
.plot.plt lscost[X;y] each 20 gd[X;y;alpha]\theta
gd[X;y;alpha]/[theta]           / obtain optimal theta
/ plot prediction of optimal theta
.plot.plt (X[;1];X$gd[X;y;alpha]/[theta])
first flip .qml.mlsq[X;flip enlist y] / qml least squares
solve[X;y]                            / normal equations
enlist[y] lsq flip X                  / q least squares

data:("FFF";",")0:`ex1data2.txt
.plot.plt data
X:1f,'flip zscore each data 0 1  / normalize and add intercept
y:data 2
alpha:.01
theta:count[first X]#0f
4000 gd[X;y;alpha]/ theta

first flip .qml.mlsq[X;flip enlist y] / qml least squares
solve[X;y]                            / normal equations
enlist[y] lsq flip X                  / q least squares


