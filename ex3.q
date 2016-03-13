\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

sigmoid:{1f%1f+exp neg x}
/ logistic regression cost
lrcost:{[X;y;theta](-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:sigmoid X$theta}
lrgrad:{[X;y;theta](1f%count y)*flip[X]$sigmoid[X$theta]-y}
/ regularized lrcost/lrgrad
rlrcost:{[X;y;l;theta]lrcost[X;y;theta]+(l%2*count y)*theta$@[theta;0;:;0f]}
rlrgrad:{[X;y;l;theta]lrgrad[X;y;theta]+(l%count y)*@[theta;0;:;0f]}
rlrcostgrad:{[X;y;l;theta](rlrcost[X;y;l;theta];rlrgrad[X;y;l;theta])}

onevsall:{[X;y;nlbls;lambda]
 theta:(1+count X 0)#0f;
 theta:(.fmincg.fmincg[50;;theta] rlrcostgrad[1f,'X;;lambda] "f"$y=0N!) peach 1+til nlbls;
/ theta:(.qml.minx[`iter,50,`quiet`full;;enlist theta] {[X;y;l](rlrcost[X;y;l]@;enlist rlrgrad[X;y;l]@)}[1f,'X;;lambda] "f"$y=0N!) peach 1+til nlbls;
/ theta:flip first each theta`last;
 theta}
predict:{[X;theta](1f,'X)$theta} / regression predict
lpredict:(')[sigmoid;predict]    / logistic regression predict
wmax:first idesc@                / where max?
predictonevsall:{wmax each x lpredict/ y} / predict each number and pick best

\
\cd /Users/nick/Downloads/machine-learning-ex3/ex3
X:flip (400#"F";",")0:`:ex3data1.csv / 5000 20x20 bitmaps
y:first (1#"F";",")0:`:ex3data2.csv  / integers 1-10 (10=0)

/ plot 10 random bitmaps
(show .plot.plot[20;20;" ",.plot.c] .plot.hmap 20 cut) each -10?X

nlbls:10
lambda:.1
theta:onevsall[X;y;nlbls;lambda] / train one set of parameters for each number
100*avg y=1+predictonevsall[X] enlist theta / what percent did we get correct?
