\l ml.q
\l mnist.q
\l plot.q
\l fmincg.q
/\l qml.q
\c 20 80

/ box-muller (copied from qtips/stat.q) (m?-n in k6)
bm:{
 if[count[x] mod 2;'`length];
 x:2 0N#x;
 r:sqrt -2f*log first x;
 theta:2f*acos[-1f]*last x;
 x: r*cos theta;
 x,:r*sin theta;
 x}

/ (h)ttp (g)et (.Q.hg in 3.4)
hg:{
 h:(1+i 1)_ first x:(0,(count x)^(i:where "/"=x)2)_x:string x;
 m:"GET ",((2<count i)_"/",x 1)," HTTP/1.1\r\nHost: ",h,s:"\r\n\r\n";
 c:(4+first r ss s)_r:(`$((count first x)^i 2)# first x) m;
 c}

\
/ define a plotting function
plt:.plot.plot[28;15;1_.plot.c16]

/ plot sin x
plt sin .01*til 1000

/ uniform random variables
plt 100000?1f

/ normal random variables (k6:10000?-1f)
plt bm 10000?1f

/ 2 sets of independant normal random variables
/ NOTE: matrix variables are uppercase
X:(bm 10000?) each 1 1f

/ TIP: suppress the desire to flip matrices

/ Matlab/Octave/R all store data in columns

/ q needs the ability to tag matrices so they can be displayed (not
/ stored) flipped
flip X

/ plot x,y
plt X

/ correlate x and y
rho:.8
X[0]:(rho;sqrt 1f-rho*rho)$X

/ plot correlated x,y
plt X

/ NOTE: use +$+ for both dot product and matrix multiplication

/ add intercept
.ml.addint X

/ fit a line with intercept
Y:-1#X
X:1#X
show THETA:Y lsq .ml.addint X

/ plot fitted line
plt X,.ml.predict[X] THETA

/ fast but not numerically stable
.ml.mlsq

/ NOTE: use 'X$/:Y' instead of 'Y mmu flip X' to avert flipping large
/ matrices
\ts Y mmu flip X
\ts X$/:Y

/ qml uses QR decomposition for a more numerically stable fit, but it
/ makes us flip both X and Y
\ts flip .qml.mlsq[flip .ml.addint X;flip Y]

/ nice to have closed form solution, but what if we don't?

/ gradient descent
alpha:.1
THETA:1 2#0f
.ml.gd[alpha;.ml.lingrad[X;Y]] THETA

/ n steps
2 .ml.gd[alpha;.ml.lingrad[X;Y]]/ THETA
/ until cost within tolerance
(.4<.ml.lincost[X;Y]@) .ml.gd[alpha;.ml.lingrad[X;Y]]/ THETA
/ until convergence
.ml.gd[alpha;.ml.lingrad[X;Y]] over THETA

/ how to represent a binary outcome?
/ use sigmoid function

plt .ml.sigmoid .1*-50+til 100

/ classification
X:30+100*(100?1f;.01*til 100)
Y:enlist .ml.sigmoid .1*-150+sum X
plt X,Y

/ logistic regression cost
/ NOTE: accepts a list of thetas (in preparation for nn)
THETA: (1;3)#0f;
.ml.logcost[X;Y;enlist THETA]

/ logistic regression gradient
.ml.loggrad[X;Y;enlist THETA]
/ iterate 100000 times
100000 .ml.gd[.0005;.ml.loggrad[X;Y]]/ enlist THETA
/ iterate until cost is less than .5
(.5<.ml.logcost[X;Y]@) .ml.gd[.0005;.ml.loggrad[X;Y]]/ enlist THETA
/ iterate until convergence
/.ml.gd[.0005;.ml.loggrad[X;Y]] over enlist THETA

/ we can use qml and the just the cost function to compute gradient
/ and optimal step size

opts:`iter,1000,`full`quiet /`rk`slp`tol,1e-8
/ use cost function only
f:.ml.logcost[X;Y]enlist enlist@
.qml.minx[opts;f;THETA]

/ or compute the result even faster with the most recent version of
/ qml, by passing the gradient function as well
f:.ml.logcostgradf[X;Y]
.qml.minx[opts;f;THETA]

/ but the gradient often shares computations with the cost.  providing
/ a single function that calculates both and a better minimization
/ function makes finding the optimal parameters childs play
/ NOTE: use '\r' to show in-place updates to progress across iterations
THETA:first .fmincg.fmincg[100;.ml.logcostgrad[X;Y];THETA 0]

/ compare plots
plt X,Y
plt X,.ml.lpredict[X] enlist THETA

/ digit recognition

/ download data
f:("train-labels-idx1-ubyte";"train-images-idx3-ubyte";"t10k-labels-idx1-ubyte";"t10k-images-idx3-ubyte")
{if[()~key hsym `$x;(`$":",x) 1: hg hsym `$"http://yann.lecun.com/exdb/mnist/",x,:".gz";system"gunzip -v ",x]} each f

/ load training data
Y:enlist y:"i"$.mnist.ldidx read1 `$"train-labels-idx1-ubyte"
X:flip "f"$raze each .mnist.ldidx read1 `$"train-images-idx3-ubyte"

/ visualize data
/ redefine plot (to include space)
plt:.plot.plot[28;15;.plot.c10] .plot.hmap flip 28 cut
plt  X[;rand count X 0]

/ learn (one vs all)
lbls:til 10
lambda:1
THETA:(1;1+count X)#0f
mf:(first .fmincg.fmincg[20;;THETA 0]@) / pass minimization func as parameter
cgf:.ml.rlogcostgrad[lambda;X]          / cost gradient function

/ multiple runs of logistic regression (one for each digit)
/ train one set of parameters for each number
/ NOTE: peach across digits
THETA:.ml.onevsall[mf;cgf;Y;lbls]

100*avg y=p:.ml.predictonevsall[X] enlist THETA / what percent did we get correct?

/ what did we get wrong?
p w:where not y=p
plt X[;i:rand w]
([]p;y) i

/ confirm analytic gradient is equal to numeric gradient
.ml.checknngradients[.1f;3 5 3]

/ learn (neural network with 1 hidden layer)
n:784 30 10
YMAT:.ml.diag[last[n]#1f]@\:"i"$y

/ need random weights

theta:2 raze/ .ml.ninit'[-1_n;1_n];

/ batch gradient descent - steepest gradient (might find local minima)
first .fmincg.fmincg[1;.ml.nncost[0f;n;X;YMAT];theta]

/ NOTE: qml throws a `limit error (too many elements)
/ .qml.minx[`quiet`full`iter,1;.ml.nncostf[0f;n;X;YMAT];enlist theta]

/ stochastic gradient descent
/ - jumpy (can find global minima)
/ - converges faster (but might never stop)
/ on-line if n = 1
/ mini-batch if n>1 (vectorize calculations)

mf:{first .fmincg.fmincg[5;.ml.nncost[0f;n;X[;y];YMAT[;y]];x]}

/https://www.quora.com/Whats-the-difference-between-gradient-descent-and-stochastic-gradient-descent
/ A: permutate, run n non-permuted epochs
i:{neg[x]?x} count X 0;X:X[;i];YMAT:YMAT[;i];Y:Y[;i];y:Y 0
theta:1 .ml.sgd[mf;til;10000;X]/ theta
/ B: run n permuted epochs
theta:1 .ml.sgd[mf;{neg[x]?x};10000;X]/ theta
/ C: run n random (with replacement) epochs (aka bootstrap)
theta:1 .ml.sgd[mf;{x?x};10000;X]/ theta

/ NOTE: can run any above example with cost threshold
theta:(1f<first .ml.nncost[0f;n;X;YMAT]@) .ml.sgd[mf;{neg[x]?x};10000;X]/ theta

/ TIP: 3.4 {neg[x]?x} == 0N?x

/ what is the total cost?
first .ml.nncost[0f;n;X;YMAT;theta]

/ how well did we learn
100*avg y=p:.ml.predictonevsall[X] .ml.mcut[n] theta

/ visualize hidden features
plt 1_ last first .ml.mcut[n] theta

/ view a few mistakes
p w:where not y=p
plt X[;rw:rand w]
([]p;y) rw

/ load testing data
Yt:enlist yt:"i"$.mnist.ldidx read1 `$"t10k-labels-idx1-ubyte"
Xt:flip "f"$raze each .mnist.ldidx read1 `$"t10k-images-idx3-ubyte"

/ how well can we predict
100*avg yt=p:.ml.predictonevsall[Xt] .ml.mcut[n] theta

/ view a few mistakes
p w:where not yt=p
plt Xt[;rw:rand w]
([]p;yt) rw

/ which digits are difficult to learn
desc count each group yt w

/ which digits are often mistaken for each other
desc count each group ([]p;yt) w

/ clustering

/ redefine plot (to drop space)
plt:.plot.plot[28;15;1_.plot.c10]
k:3 / 3 centroids

show C:"f"$k?/:2#20 / initial centroids
X:raze each C,''C+bm(2;k)#100?/:(2*k)#1f
plt X

/ the number of centroids (k) becomes the actual centroids after the
/ initial iteration
.ml.kmeans[X]\[k]               / euclidian distance

/ NOTE: picks x and y from data (but not necessarily (x;y))
.ml.kmedians[X]\[k]             / manhattan distance (taxicab metric)

/ classic machine learning iris data
iris:("FFFFS";1#",") 0: `iris.csv
X:value flip 4#/:iris
plt X 3

/ find 3 centroids
flip  C:.ml.kmeans[X]/[-3]

/ classify
show g:.ml.cgroup[.ml.edist;X;C]

/ how well can we predict
100*avg iris.species=distinct[iris.species] .ml.ugrp g

/ plot errors with increasing number of centroids
plt (.ml.distortion .ml.ecdist[X] .ml.kmeans[X]@) each neg 1+til 10

