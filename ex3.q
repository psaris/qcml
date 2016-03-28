\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

sigmoid:{1f%1f+exp neg x}
/ TODO: merge regularized
/ logistic regression cost
lrcost:{[X;y;theta](-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:sigmoid theta$X}
lrgrad:{[X;y;theta](1f%count y)*X$\:sigmoid[theta$X]-y}
/ regularized lrcost/lrgrad
rlrcost:{[X;y;l;theta]lrcost[X;y;theta]+(l%2*count y)*theta$@[theta;0;:;0f]}
rlrgrad:{[X;y;l;theta]lrgrad[X;y;theta]+(l%count y)*@[theta;0;:;0f]}
rlrcostgrad:{[X;y;l;theta](rlrcost[X;y;l;theta];rlrgrad[X;y;l;theta])}

onevsall:{[n;X;y;nlbls;lambda]
 X:((1;count X 0)#1f),X;
 theta:count[X]#0f;
 theta:(first .fmincg.fmincg[n;;theta] rlrcostgrad[X;;lambda] "f"$y=0N!) peach 1+til nlbls;
/ theta:(.qml.minx[`iter,50,`quiet`full;;enlist theta] {[X;y;l](rlrcost[X;y;l]@;enlist rlrgrad[X;y;l]@)}[1f,'X;;lambda] "f"$y=0N!) peach 1+til nlbls;
/ theta:flip first each theta`last;
 theta}
predict:{[X;theta]theta$((1;count X 0)#1f),X} / regression predict
lpredict:(')[sigmoid;predict]    / logistic regression predict
wmax:first idesc@                / where max?
/ predict each number and pick best
predictonevsall:{[X;theta]wmax each flip X lpredict/ theta}

\
\cd /Users/nick/Downloads/machine-learning-ex3/ex3
X:(400#"F";",")0:`:ex3data1.csv / 5000 20x20 bitmaps
y:first (1#"F";",")0:`:ex3data2.csv  / integers 1-10 (10=0)

/ plot 10 random bitmaps
(show .plot.plot[20;20;" ",.plot.c] .plot.hmap 20 cut) each flip X[;-10?til count y]

nlbls:10
lambda:.1
theta:onevsall[50;X;y;nlbls;lambda] / train one set of parameters for each number
100*avg y=1+predictonevsall[X] enlist theta / what percent did we get correct?
