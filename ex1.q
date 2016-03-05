\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/qml/src/qml.q

/ least squares cost function
lscost:{[X;y;theta](1f%2*count y)*y$y-:X$theta}
/ gradient descent
gd:{[X;y;alpha;theta] theta+(alpha%count y)*flip[X]$y-X$theta}
/ normal equations
solve:{[X;y]inv[fX$X]$(fX:flip X)$y} 

data:flip ("FF";",")0:`$":/Users/nick/Downloads/machine-learning-ex1/ex1/ex1data1.txt"
plt flip data
X:1f,'data[;0]                  / add intercept
y:data[;1]
theta:count[first X]#0f         / initial guess
alpha:.01                       / learning rate
lscost[X;y;theta]               / least squares cost
plt lscost[X;y] each 15000 gd[X;y;alpha]\theta / plot cost function of each gd step
gd[X;y;alpha]/[theta]                          / obtain optimal theta
plt (X[;1];X$gd[X;y;alpha]/[theta]) / plot prediction of optimal theta
first flip .qml.mlsq[X;flip enlist y] / qml least squares
solve[X;y]
enlist[y] lsq flip X                  / q least squares

data:flip ("FFF";",")0:`$":/Users/nick/Downloads/machine-learning-ex1/ex1/ex1data2.txt"
plt flip data
X:data[;0 1]
y:data[;2]
/ feature normalize
X:X -\: avg X
X:X %\: dev each flip X
/ add intercept
X:1f,'X
alpha:.01
theta:count[first X]#0f
4000 gd[X;y;alpha]/ theta

first flip .qml.mlsq[X;flip enlist y] / qml least squares
solve[X;y]                            / normal equations
enlist[y] lsq flip X                  / q least squares


