\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

/ ex 4
sigmoid:{1f%1f+exp neg x}
sigmoidgrad:{x*1f-x:sigmoid x}
predict:{[X;theta]theta$((1;count X 0)#1f),X} / regression predict
lpredict:(')[sigmoid;predict]   / logistic regression predict
/ regularized logistic regression lrcost
rlrcost:{[l;X;y;theta]
 J:(-1f%count y 0)*sum (y*log x)+(1f-y)*log 1f-x:X lpredict/ theta;
 if[l>0f;J+:(sum l%2*n*n:count y 0)*x$x:2 raze/ @[;0;:;0f]''[theta]];
 J}
lrcost:rlrcost[0f]

/ regularized logistic regression gradient
rlrgrad:{[l;X;y;theta]
 n:count y 0;
 a:lpredict\[enlist[X],theta];
 d:last[a]-y;
 a:{((1;count x 0)#1f),x}each -1_a;
 d:{[d;theta;a]1_(flip[theta]$d)*a*1f-a}\[d;reverse 1_theta;reverse 1_a],enlist d;
 g:(a($/:)'d)%n;
 / regularization
 if[l>0f;g+:(l%n)*@[;0;:;0f]''[theta]];
 g}
lrgrad:rlrgrad[0f]

nncost:{[X;ymat;l;n;theta] / combined cost and gradient for efficieny
 theta:unraze[n] theta;
 x:last a:lpredict\[enlist[X],theta];
 n:count ymat 0;
 J:sum (-1f%n)*sum each (ymat*log x)+(1f-ymat)*log 1f-x;
 if[l>0f;J+:(l%2*n)*{x$x}2 raze/ @[;0;:;0f]''[theta]];
 d:x-ymat;
 a:{((1;count x 0)#1f),x}each -1_a;
 d:{[d;theta;a]1_(flip[theta]$d)*a*1f-a}\[d;reverse 1_theta;reverse 1_a],enlist d;
 g:(a($/:)'d)%n;
 / regularization
 if[l>0f;g+:(l%n)*@[;0;:;0f]''[theta]];
 (J;2 raze/ g)}


predictonevsall:{[X;theta]wmax each flip X lpredict/ theta}
wmax:first idesc@                               / where max
rweights:{neg[e]+x cut (x*y)?2*e:sqrt 6%y+x+:1} / random weights


/ learn theta using qml conmax
learn:{[i;n;l;X;ymat]
 theta:2 raze/ rweights'[-1_n;1_n];
 J:0N!sum rlrcost[l;X;ymat]unraze[n]@;
 G:0N!2 raze/ rlrgrad[l;X;ymat]unraze[n]@;
 opts:`iter,i,`quiet`full;
 theta:.qml.minx[opts;(J;G);enlist theta];
 theta:first theta`last;
 theta}

/ learn theta using fmincg
learn:{[i;n;l;X;y]
 theta:2 raze/ rweights'[-1_n;1_n];
 F:nncost[X;y;l;n];
 theta:.fmincg.fmincg[i;F;theta];
 theta}

/ cut a single vector
unraze:{[n;x](1+-1_n) cut' (sums {x*y+1} prior -1_n) cut x}
diag:{$[0h>t:type x;x;@[n#abs[t]$0;;:;]'[til n:count x;x]]}

checknngradients:{[l]
 n: 3 5 3;
 theta1:rweights . n 0 1;
 theta2:rweights . n 1 2;
 X:flip rweights[-1+n 0;5];
 y:1+(1+til 5) mod 3;
 ymat:flip diag[n[2]#1f]"i"$y-1;
 theta:2 raze/ (theta1;theta2);
 g:2 raze/ rlrgrad[l;X;ymat] unraze[n] theta;
 f:(sum rlrcost[l;X;ymat]unraze[n]@);
 ng:numgrad[f;theta] count[theta]#1e-4;
 (g;ng)}

/ (f)unction, x, (e)psilon
/ compute partial derivatives if e is a list
numgrad:{[f;x;e](.5%e)*{x[y+z]-x[y-z]}[f;x] peach diag e}

\
checknngradients .1f

\cd /Users/nick/Downloads/machine-learning-ex4/ex4
X:(400#"F";",")0:`:ex4data1.csv
y:first (1#"F";",")0:`:ex4data2.csv
theta1:flip (401#"F";",") 0:`:theta1.csv
theta2:flip (26#"F";",") 0:`:theta2.csv

predict/[X;(theta1;theta2)]
ymat:diag[10#1f]@\:"i"$y-1
0.28762916516131876 = sum rlrcost[0f;X;ymat] (theta1;theta2)
0.38376985909092381 = sum rlrcost[1f;X;ymat] (theta1;theta2)
0.026047433852894011 = sum 2 raze/ rlrgrad[0f;X;ymat] (theta1;theta2)
0.0099559365856808548 = sum 2 raze/ rlrgrad[1f;X;ymat] (theta1;theta2)

n:400 25 10;
ymat:diag[last[n]#1f]@\:"i"$y-1
\ts sum each   sum each g:unraze[n] last nncost[X;ymat;1f;n;2 raze/ (theta1;theta2)]
theta:2 raze/ rweights'[-1_n;1_n];
.fmincg.fmincg[50;nncost[X;ymat;0f;n];theta]
nncost[X;ymat;0f;n;2 raze/ (theta1;theta2)]

theta:2 raze/ rweights'[-1_n;1_n];
theta:2 raze/ (theta1;theta2)
theta:first .fmincg.fmincg[50;nncost[X;ymat;0;n];theta]

100*avg y=1+predictonevsall[X]unraze[n] theta
/ visualize hidden features
plt:.plot.plot[70;25;" ",.plot.c] .plot.hmap 20 cut
plt 1_first theta1

/ mistakes
w:-4?where not y=p:1+predictonevsall[X]unraze[n] theta
(,') over plt each flip X[;w]
`p`a!(p 4#w;y 4#w)
