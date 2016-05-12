\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/qml/src/qml.q

\
\c 50 100
.plot.plt .ml.sigmoid .1*-50+til 100 / plot sigmoid function
\cd /Users/nick/Downloads/machine-learning-ex2/ex2
data:("FFF";",")0:`:ex2data1.txt
.plot.plt data
X:2#data
y:-1#data
theta:(1;1+count X)#0f
.ml.logcost[X;y;enlist theta]        / logistic regression cost
.ml.loggrad[X;y;enlist theta]        / logistic regression gradient

/ rk:runge–kutta, slp: success linear programming
opts:`quiet`rk`iter,7000
/ find function minimum
theta:(1;1+count X)#0f
.qml.minx[opts;.ml.logcost[X;y]enlist enlist@;theta]
/ use gradient to improve efficiency
.qml.minx[opts;.ml.logcostgradf[X;y];theta]

/ compare plots
theta:first .qml.minx[opts;.ml.logcost[X;y]enlist enlist@;theta]
.plot.plt data
.plot.plt X,.ml.lpredict[X] theta

