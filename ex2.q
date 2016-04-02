\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/qml/src/qml.q

sigmoid:{1f%1f+exp neg x}
predict:{[X;theta]theta$((1;count X 0)#1f),X} / regression predict
lpredict:(')[sigmoid;predict]   / logistic regression predict
/ logistic regression cost
lrcost:{[X;y;theta](-1f%count y 0)*sum (y*log x)+(1f-y)*log 1f-x:X lpredict/ theta}
/ logistic regression gradient
lrgrad:{[X;y;theta](1f%count y 0)*(((1;count X 0)#1f),X)$/:(X lpredict/ theta)-y}

\
\c 50 100
.plot.plt sigmoid .1*-50+til 100 / plot sigmoid function
\cd /Users/nick/Downloads/machine-learning-ex2/ex2
data:("FFF";",")0:`:ex2data1.txt
.plot.plt data
X:data 0 1
y:data 1#2
theta:(1;1+count X)#0f
lrcost[X;y;enlist theta]        / logistic regression cost
lrgrad[X;y;enlist theta]        / logistic regression gradient

/ rk:runge–kutta, slp: success linear programming
opts:`iter,7000,`full`quiet`rk
 / find function minimum
lrcost:{[X;y;theta](-1f%count y 0)*sum (y*log x)+(1f-y)*log 1f-x:X lpredict/ theta}
theta:(1;1+count X)#0f
.qml.minx[opts;sum lrcost[X;y]enlist enlist@;theta]
 / use gradient to improve efficiency
.qml.minx[opts][(sum lrcost[X;y]enlist enlist@;lrgrad[X;y]enlist enlist@);theta]

/ compare plots
theta:first .qml.minx[opts;sum lrcost[X;y]enlist enlist@;theta]
.plot.plt data
.plot.plt X,lpredict[X] theta

