\d .ml

addint:{((1;count x 0)#1f),x}   / add intercept

predict:{[X;THETA]THETA$addint X} / regression predict

/ regularized linear regression cost
rlincost:{[l;X;Y;THETA]
 J:sum (1f%2*n:count Y 0)*sum Y$/:Y-:predict[X;THETA];
 if[l>0f;J+:(l%2*n)*x$x:raze @[;0;:;0f]'[THETA]];
 J}
lincost:rlincost[0f]

/ regularized linear regression gradient
rlingrad:{[l;X;Y;THETA]
 g:(1f%n:count Y 0)*addint[X]$/:predict[X;THETA]-Y;
 if[l>0f;g+:(l%n)*@[;0;:;0f]'[THETA]];
 g}
lingrad:rlingrad[0f]

/ gf: gradient function
gd:{[alpha;gf;THETA] THETA-alpha*gf THETA} / gradient descent

mlsq:{flip inv[y$/:y]$x$/:y}    / normal equations

zscore:{(x-avg x)%dev x}        / feature normalization

sigmoid:{1f%1f+exp neg x}       / sigmoid function

lpredict:(')[sigmoid;predict]   / logistic regression predict

/ logistic regression cost
lcost:{sum (-1f%count y 0)*sum each (y*log x)+(1f-y)*log 1f-x}

/ regularized logistic regression cost
rlogcost:{[l;X;Y;THETA]
 J:lcost[X lpredict/ THETA;Y];
 if[l>0f;J+:(l%2*count Y 0)*x$x:2 raze/ @[;0;:;0f]''[THETA]]; / regularization
 J}
logcost:rlogcost[0f]

/ regularized logistic regression gradient
rloggrad:{[l;X;Y;THETA]
 n:count Y 0;
 a:lpredict\[enlist[X],THETA];
 D:last[a]-Y;
 a:addint each -1_a;
 D:{[D;THETA;a]1_(flip[THETA]$D)*a*1f-a}\[D;reverse 1_THETA;reverse 1_a],enlist D;
 g:(a($/:)'D)%n;
 if[l>0f;g+:(l%n)*@[;0;:;0f]''[THETA]]; / regularization
 g}
loggrad:rloggrad[0f]

rlogcostgrad:{[l;X;Y;THETA]
 J:sum rlogcost[l;X;Y;2 enlist/ THETA];
 g:2 raze/ rloggrad[l;X;Y;2 enlist/ THETA];
 (J;g)}
logcostgrad:rlogcostgrad[0f]

rlogcostgradf:{[l;X;Y]
 Jf:(sum rlogcost[l;X;Y]enlist enlist@);
 gf:(raze rloggrad[l;X;Y]enlist enlist @);
 (Jf;gf)}
logcostgradf:rlogcostgradf[0f]

/ normalized initialization - Glorot and Bengio (2010)
ninit:{sqrt[6f%x+y]*-1f+(x+:1)?/:y#2f}

/ (m)inimization (f)unction, (c)ost (g)radient (f)unction
onevsall:{[mf;cgf;Y;lbls] (mf cgf "f"$Y=) peach lbls}

imax:{x?max x}                  / index of max element
imin:{x?min x}                  / index of min element

/ predict each number and pick best
predictonevsall:{[X;THETA]imax each flip X lpredict/ THETA}

/ cut a vector into n matrices
mcut:{[n;x](1+-1_n) cut' (sums {x*y+1} prior -1_n) cut x}
diag:{$[0h>t:type x;x;@[n#abs[t]$0;;:;]'[til n:count x;x]]}

/ (f)unction, x, (e)psilon
/ compute partial derivatives if e is a list
numgrad:{[f;x;e](.5%e)*{x[y+z]-x[y-z]}[f;x] peach diag e}

checknngradients:{[l;n]
 theta:2 raze/ THETA:ninit'[-1_n;1_n];
 X:flip ninit[-1+n 0;n 1];
 y:1+(1+til n 1) mod last n;
 YMAT:flip diag[last[n]#1f]"i"$y-1;
 g:2 raze/ rloggrad[l;X;YMAT] THETA; / analytic gradient
 f:(rlogcost[l;X;YMAT]mcut[n]@);
 ng:numgrad[f;theta] count[theta]#1e-4; / numerical gradient
 (g;ng)}

/ n can be any network topology dimension
nncost:{[l;n;X;YMAT;theta] / combined cost and gradient for efficiency
 THETA:mcut[n] theta;
 Y:last a:lpredict\[enlist[X],THETA];
 n:count YMAT 0;
 J:lcost[Y;YMAT];
 if[l>0f;J+:(l%2*n)*{x$x}2 raze/ @[;0;:;0f]''[THETA]]; / regularization
 D:Y-YMAT;
 a:addint each -1_a;
 D:{[D;THETA;a]1_(flip[THETA]$D)*a*1f-a}\[D;reverse 1_THETA;reverse 1_a],enlist D;
 g:(a($/:)'D)%n;
 if[l>0f;g+:(l%n)*@[;0;:;0f]''[THETA]]; / regularization
 (J;2 raze/ g)}

nncostf:{[l;n;X;YMAT]
 Jf:(first nncost[l;n;X;YMAT]@);
 gf:(last nncost[l;n;X;YMAT]@);
 (Jf;gf)}

/ stochastic gradient descent

/ successively call (m)inimization (f)unction with (THETA) and
/ randomly sorted (n)-sized chunks generated by (s)ampling (f)unction
sgd:{[mf;sf;n;X;THETA]THETA mf/ n cut sf count X 0}

/ k-means

edist:{sum x*x-:y}              / euclidian distance
mdist:{sum abs x-y}             / manhattan distance (taxicab metric)

hmean:{1f%avg 1f%x}             / harmonic mean

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid
cgroup:{[df;X;C] group imin each flip df[X] each flip C}

/ k-(means|medians) algorithm

/ stuart lloyd's algorithm. using a (d)istance (f)unction and
/ (m)ean/edian (f)unction, find (k)-centroids in the data (X) starting
/ with a (C)entroid list. if C is an atom, use it to randomly
/ initialize C. if negative, use "Forgy" method and randomly pick k
/ centroids.  if positive, use "Random Partition" method to randomly
/ assign to k clusters.
lloyd:{[df;mf;X;C]
 if[0h>type C;if[0>C;C:X@\:C?count X 0]];
 g:$[0h>type C;group count[X 0]?C;cgroup[df;X;C]]; / assignment step
 C:mf''[X@\:value g];                              / update step
 C}

kmeans:lloyd[edist;avg]
kmedians:lloyd[mdist;med]
khmeans:lloyd[edist;hmean]

/ using the (d)istance (f)unction, cluster the data (X) into groups
/ defined by the closest (C)entroid and return the distance
cdist:{[df;X;C] k!df[X@\:value g] C@\:k:key g:cgroup[df;X;C]}
ecdist:cdist[edist]
mcdist:cdist[mdist]

distortion:sum sum each

/ ungroup (inverse of group)
ugrp:{(key[x] where count each value x)iasc raze x}
