\d .ml

/ add intercept
addint:{((1;count x 0)#1f),x}

/ regression predict
predict:{[X;theta]theta$addint X}

/ regularized linear regression cost
rlincost:{[l;X;y;theta]
 J:sum (1f%2*n:count y 0)*sum y$/:y-:X predict/ theta;
 if[l>0f;J+:(l%2*n)*x$x:2 raze/ @[;0;:;0f]''[theta]];
 J}
lincost:rlincost[0f]

/ regularized linear regression gradient
rlingrad:{[l;X;y;theta]
 g:(1f%n:count y 0)*addint[X]$/:predict[X;theta]-y;
 if[l>0f;g+:(l%n)*@[;0;:;0f]'[theta]];
 g}
lingrad:rlingrad[0f]

/ gradient descent (gf: gradient function)
gd:{[alpha;gf;theta] theta-alpha*gf theta}

/ normal equations
mlsq:{flip inv[y$/:y]$x$/:y}

/ feature normalization
zscore:{(x-avg x)%dev x}

/ sigmoid function
sigmoid:{1f%1f+exp neg x}

/ logistic regression predict
lpredict:(')[sigmoid;predict]

/ regularized logistic regression lrcost
rlogcost:{[l;X;y;theta]
 J:sum (-1f%n:count y 0)*sum (y*log x)+(1f-y)*log 1f-x:X lpredict/ theta;
 if[l>0f;J+:(l%2*n)*x$x:2 raze/ @[;0;:;0f]''[theta]];
 J}
logcost:rlogcost[0f]

/ regularized logistic regression gradient
rloggrad:{[l;X;y;theta]
 n:count y 0;
 a:lpredict\[enlist[X],theta];
 d:last[a]-y;
 a:{((1;count x 0)#1f),x}each -1_a;
 d:{[d;theta;a]1_(flip[theta]$d)*a*1f-a}\[d;reverse 1_theta;reverse 1_a],enlist d;
 g:(a($/:)'d)%n;
 / regularization
 if[l>0f;g+:(l%n)*@[;0;:;0f]''[theta]];
 g}
loggrad:rloggrad[0f]

rlogcostgrad:{[l;X;y;theta]
 J:sum rlogcost[l;X;y;2 enlist/ theta];
 g:rloggrad[l;X;y;2 enlist/ theta];
 (J;2 raze/ g)}
logcostgrad:rlogcostgrad[0f]


onevsall:{[n;X;y;nlbls;l]
 theta:(1;1+count X)#0f;
 f:.ml.rlogcostgrad[l;X];
 theta:(first .fmincg.fmincg[n;;first theta] f "f"$y=) peach 1+til nlbls;
 theta}
wmax:first idesc@                / where max?
/ predict each number and pick best
predictonevsall:{[X;theta]wmax each flip X lpredict/ theta}


/ cut a single vector
unraze:{[n;x](1+-1_n) cut' (sums {x*y+1} prior -1_n) cut x}
diag:{$[0h>t:type x;x;@[n#abs[t]$0;;:;]'[til n:count x;x]]}

rweights:{neg[e]+x cut (x*y)?2*e:sqrt 6%y+x+:1} / random weights

/ (f)unction, x, (e)psilon
/ compute partial derivatives if e is a list
numgrad:{[f;x;e](.5%e)*{x[y+z]-x[y-z]}[f;x] peach diag e}

checknngradients:{[l]
 n: 3 5 3;
 theta1:rweights . n 0 1;
 theta2:rweights . n 1 2;
 X:flip rweights[-1+n 0;5];
 y:1+(1+til 5) mod 3;
 ymat:flip diag[n[2]#1f]"i"$y-1;
 theta:2 raze/ (theta1;theta2);
 g:2 raze/ rloggrad[l;X;ymat] unraze[n] theta;
 f:(rlogcost[l;X;ymat]unraze[n]@);
 ng:numgrad[f;theta] count[theta]#1e-4;
 (g;ng)}

/ n can be any network topology dimension
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

/ learn theta using qml conmax
learn:{[i;n;l;X;ymat]
 theta:2 raze/ rweights'[-1_n;1_n];
 J:rlrcost[l;X;ymat]unraze[n]@;
 G:2 raze/ rlrgrad[l;X;ymat]unraze[n]@;
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

/TODO: get more efficient method
covm:{(1%count x 0)*x$/:\:x}
/cvm:{(x+flip(not n=\:n)*x:(n#'0.0),'(x$/:'(n:til count x)_\:x)%count first x)-a*\:a:avg each x}

pca:{[k;X]
 Xn:zscore each X;
 v:last .qml.mev covm Xn;
 Z:(k#v)$Xn; / project onto k dimensions
 Xr:flip[k#v]$Z; /reconstruct initial image
 (v;Z;Xr)}