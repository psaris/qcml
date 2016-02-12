\l /Users/nick/q/plot.q
\l /Users/nick/q/qml/src/qml.q


/ ex 3

sigmoid:{1f%1f+exp neg x}
/ logistic regression cost
lrcost:{[X;y;theta](-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:sigmoid X$theta}
lrgrad:{[X;y;theta](1f%count y)*flip[X]$sigmoid[X$theta]-y}
/ regularized lrcost/lrgrad
rlrcost:{[X;y;l;theta]lrcost[X;y;theta]+(l%2*count y)*theta$@[theta;0;:;0f]}
rlrgrad:{[X;y;l;theta]lrgrad[X;y;theta]+(l%count y)*@[theta;0;:;0f]}

X:flip (400#"F";",")0:`$":/Users/nick/Downloads/machine-learning-ex3/ex3/ex3data1.csv"
y:first (1#"F";",")0:`$":/Users/nick/Downloads/machine-learning-ex3/ex3/ex3data2.csv"

nlbls:10
input_layer_size:400
m:count X
rndi:neg[m]?m
sel:X 10#rndi
(.plot.plot[20;10;.plot.c] .plot.hmap 20 cut) each sel

lambda:.1
onevsall:{[X;y;nlbls;lambda]
 theta:(1+count X 0)#0f;
 X:1f,'X;
 theta:(.qml.minx[`iter,50,`quiet`full;;enlist theta] {[X;y;l](rlrcost[X;y;l]@;enlist rlrgrad[X;y;l]@)}[X;;lambda] "f"$y=0N!) peach 1+til nlbls;
 theta:flip first each theta`last;
 theta}
theta:onevsall[X;y;nlbls;lambda]
predict:{[X;theta](1f,'X)$theta}
lpredict:(')[sigmoid;predict]
predictonevsall:{wmax each x lpredict/ y}
wmax:first idesc@
100*avg y=1+predictonevsall[X] enlist theta

theta1:(401#"F";",") 0: `$":/Users/nick/Downloads/machine-learning-ex3/ex3/theta1.csv"
theta2:(26#"F";",") 0: `$":/Users/nick/Downloads/machine-learning-ex3/ex3/theta2.csv"
100*avg y=1+predictonevsall[X;(theta1;theta2)]
