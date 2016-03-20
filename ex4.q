\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

/ ex 4
sigmoid:{1f%1f+exp neg x}
sigmoidgrad:{x*1f-x:sigmoid x}
predict:{[X;theta](1f,'X)$theta}
lpredict:(')[sigmoid;predict]   / logistic regression predict
/ logistic regression cost
lrcost:{[X;y;theta](-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:lpredict/[X;theta]}
/ regularized lrcost
rlrcost:{[l;X;y;theta]lrcost[X;y;theta]+(l%2*count[y]*count first y)*x$x:2 raze/ 1_/:theta}
predictonevsall:{wmax each x lpredict/ y}
wmax:first idesc@                               / where max
rweights:{neg[e]+y cut (x*y)?2*e:sqrt 6%y+x+:1} / random weights

nncost:{[X;ymat;lambda;ninput;nhidden;nlbls;theta]
 i:nhidden*ninput+1;
 theta1:nhidden cut i#theta;
 theta2:nlbls cut i _theta;
 a1:1f,'X;
 a2:1f,'sigmoid a1$theta1;
 a3:sigmoid a2$theta2;
 n:count ymat;
 J:sum (-1f%n)*sum each (ymat*log a3)+(1f-ymat)*log 1f-a3;
 J+:(lambda%2*n)*{x$x}2 raze/ 1_/:(theta1;theta2);
 d3:a3-ymat;
 d2:1_'(d3$flip theta2)*a2*1f-a2;
 theta2g:(flip[a2]$d3)%n;
 theta1g:(flip[a1]$d2)%n;
 theta2r:(lambda%ninput)*theta2;
 theta2r[0]*:0f;
 theta2g+:theta2r;
 theta1r:(lambda%ninput)*theta1;
 theta1r[0]*:0f;
 theta1g+:theta1r;
 grad:raze/[(theta1g;theta2g)];
 (J;grad)}

/ regularized logistic regression gradient
rlrgrad:{[l;X;y;theta]
 n:count y;
 a:lpredict\[enlist[X],theta];
 d:last[a]-y;
 a:1f,''-1_a;
 d:{[d;theta;a]1_'(d$flip theta)*a*1f-a}\[d;reverse 1_theta;reverse 1_a],enlist d;
 g:{(flip[x]$y)%z}'[a;d;n];
 / regularization
 if[l>0f;g+:(l%n)*@[;0;*;0f] each theta];
 g}

lrgrad:rlrgrad[0f]

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
 F:nncost[X;y;l] . n;
 theta:.fmincg.fmincg[i;F;theta];
 theta}

/ cut a single vector
unraze:{[n;x](1_n) cut' (sums {x*y+1} prior -1_n) cut x}
diag:{$[0h>t:type x;x;@[n#abs[t]$0;;:;]'[til n:count x;x]]}

checknngradients:{[l]
 n: 3 5 3;
 theta1:rweights . n 0 1;
 theta2:rweights . n 1 2;
 X:flip rweights[-1+n 0;5];
 y:1+(1+'til 5) mod 3;
 ymat:diag[n[2]#1f]"i"$y-1;
 theta:2 raze/ (theta1;theta2);
 g:2 raze/ rlrgrad[l;X;ymat] unraze[n] theta;
 f:(sum rlrcost[l;X;ymat]unraze[n]@);
 ng:numgrad[f;theta] count[theta]#1e-4;
 (g;ng)}

/ (f)unction, x, (e)psilon
/ compute partial derivatives if e is a list
numgrad:{[f;x;e](.5%e)*{x[y+z]-x[y-z]}[f;x] each diag e}

\
plt:.plot.plt .plot.hmap 20 cut
checknngradients .1f

\cd /Users/nick/Downloads/machine-learning-ex4/ex4
X:flip (400#"F";",")0:`:ex4data1.csv
y:first (1#"F";",")0:`:ex4data2.csv
theta1:(401#"F";",") 0:`:theta1.csv
theta2:(26#"F";",") 0:`:theta2.csvf
/theta:(theta1;theta2)

predict/[X;(theta1;theta2)]
ymat:diag[10#1f]"i"$y-1
sum lrcost[X;ymat] (theta1;theta2)
sum rlrcost[1f;X;ymat] (theta1;theta2)
2 raze/ rlrgrad[1f;X;ymat] (theta1;theta2)
n:400 25 10
l:1
theta:2 raze/ (theta1;theta2)
f:(sum rlrcost[l;X;ymat]unraze[n]@);
numgrad[f;theta;1e-4,(-1+count theta)#0f]


n:400 25 10;
ymat:diag[last[n]#1f]"i"$y-1
g:unraze[n] last nncost[X;ymat;1f;400;25;10;raze/[(theta1;theta2)]]
theta:2 raze/ rweights'[-1_n;1_n];
.fmincg.fmincg[50;nncost[X;ymat;0f] . n;theta]
nncost[X;ymat;0f;400;25;10;2 raze/ (theta1;theta2)]

theta:2 raze/ rweights'[-1_n;1_n];
theta:2 raze/ (theta1;theta2)
.fmincg.fmincg[50;nncost[X;ymat;0] . n;theta]
.fmincg.fmincg[50;{[X;ymat;n;theta](nncost[X;ymat;0] . n)theta}[X;ymat;n];theta]


100*avg y=1+predictonevsall[X]unraze[n] theta
/ visualize hidden features
plt:.plot.plot[70;25;".-+*#@"] .plot.hmap 20 cut
(show plt@) first  1_flip theta1

nlbls:10
m:count X
rndi:neg[m]?m
sel:X 10#rndi
/ mistakes
sel:X 10#w:where not  y=1+predictonevsall[X]unraze[n] theta
show .plot.hmap 20 cut)each sel

theta:onevsall[.1;X;y;10]
100*avg y=1+predictonevsall[X] enlist theta

