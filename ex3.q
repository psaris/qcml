\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

sigmoid:{1f%1f+exp neg x}
predict:{[X;theta]theta$((1;count X 0)#1f),X} / regression predict
lpredict:(')[sigmoid;predict]    / logistic regression predict
/ regularized logistic regression cost
rlrcost:{[l;X;y;theta]
 J:(-1f%count y 0)*sum (y*log x)+(1f-y)*log 1f-x:X lpredict/ theta;
 if[l>0f;J+:(sum l%2*n*n:count y 0)*x$x:2 raze/ @[;0;:;0f]''[theta]];
 J}
lrcost:rlrcost[0f]
/ regularized logistic regression gradient
rlrgrad:{[l;X;y;theta]
 g:enlist (1f%count y 0)*(((1;count X 0)#1f),X)$/:(X lpredict/ theta)-y; / assumes a single theta
 if[l>0f;g+:(l%count y 0)*@[;0;:;0f]''[theta]];
 g}
lrgrad:rlrgrad[0f]
/ transforms a single theta vector into a single matrix theta
rlrcostgrad:{[X;y;l;theta]
 J:sum rlrcost[l;X;y;2 enlist/ theta];
 g:rlrgrad[l;X;y;2 enlist/ theta];
 (J;2 raze/ g)}

/nncost[X;y;20f;5000 1;first theta]
/rlrcostgrad[X;y;20f;first theta]
onevsall:{[n;X;y;nlbls;lambda]
 theta:(1;1+count X)#0f;
 theta:(first .fmincg.fmincg[n;;first theta] rlrcostgrad[X;;lambda] "f"$y=) peach 1+til nlbls;
/ theta:(.qml.minx[`iter,50,`quiet`full;;enlist theta] {[X;y;l](rlrcost[X;y;l]@;enlist rlrgrad[X;y;l]@)}[1f,'X;;lambda] "f"$y=0N!) peach 1+til nlbls;
 theta}
wmax:first idesc@                / where max?
/ predict each number and pick best
predictonevsall:{[X;theta]wmax each flip X lpredict/ theta}

\
\cd /Users/nick/Downloads/machine-learning-ex3/ex3
X:(400#"F";",")0:`:ex3data1.csv / 5000 20x20 bitmaps
y:(1#"F";",")0:`:ex3data2.csv  / integers 1-10 (10=0)

/ plot 4 random bitmaps
plt:(.plot.plot[20;20;" ",.plot.c] .plot.hmap 20 cut)
(,') over  plt each flip X[;-4?til count X 0]

nlbls:10
lambda:1
theta:onevsall[100;X;y;nlbls;lambda] / train one set of parameters for each number
100*avg first[y]=1+predictonevsall[X] enlist theta / what percent did we get correct?
