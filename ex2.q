\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/qml/src/qml.q

sigmoid:{1f%1f+exp neg x}
/ logistic regression cost
lrcost:{[X;y;theta](-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:sigmoid X$theta}
/ logistic regression gradient
lrgrad:{[X;y;theta](1f%count y)*flip[X]$sigmoid[X$theta]-y}

\
.plot.plt sigmoid .1*-50+til 100 / plot sigmoid function
\cd /Users/nick/Downloads/machine-learning-ex2/ex2
data:("FFF";",")0:`:ex2data1.txt
.plot.plt data
X:1f,'flip data 0 1
y:data 2
theta:count[first X]#0f
lrcost[X;y;theta]               / logistic regression cost
lrgrad[X;y;theta]               / logistic regression gradient

/ rk:runge–kutta, slp: success linear programming
opts:`iter,7000,`full`quiet`rk
 / find function minimum
.qml.minx[opts;lrcost[X;y];enlist theta]
 / use gradient to improve efficiency
.qml.minx[opts][(lrcost[X;y]@;enlist lrgrad[X;y]@);enlist theta]


