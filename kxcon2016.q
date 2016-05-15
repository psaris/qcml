\l /Users/nick/q/ml/mnist/mnist.q
\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/kmeans.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q
\c 40 80

/ box-muller (copied from qtips/stat.q)
bm:{
 if[count[x] mod 2;'`length];
 x:2 0N#x;
 r:sqrt -2f*log first x;
 theta:2f*acos[-1f]*last x;
 x: r*cos theta;
 x,:r*sin theta;
 x}

\
/ define a plotting function
plt:.plot.plot[49;25;1_.plot.c16]

/ plot sin x
plt sin .01*til 1000

/ uniform random variables
plt 100000?1f

/ normal random variables (k6:10000?-1f)
plt bm 10000?1f

/ 2 sets of independant normal random variables
/ NOTE: matrix variables are uppercase
X:(bm 10000?) each 1 1f

/ NOTE: suppress the desire to flip matrices.

/ Matlab/Octave/R all store data in columns

/ q needs the ability to tag matrices so they can be displayed (not
/ stored) flipped
flip X

/ plot x,y
plt X

/ correlate x and y
/ TODO: implement copula?
/ http://www.sitmo.com/article/generating-correlated-random-numbers/
rho:.8
X[0]:(rho;sqrt 1-rho*rho)$X

/ plot correlated x,y
plt X

/ NOTE: use +$+ for both dot product and matrix multiplication

/ fit a line with intercept
Y:-1#X
X:1#X
show theta:Y lsq .ml.addint X

/ plot fitted line
plt X,.ml.predict[X] theta

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
theta:1 2#0f
/ n steps
2 .ml.gd[alpha;.ml.lingrad[X;Y]]/ theta
/ until cost within tolerance
(.4>.ml.lincost[X;Y]@) .ml.gd[alpha;.ml.lingrad[X;Y]]/ theta
/ until convergence
.ml.gd[alpha;.ml.lingrad[X;Y]] over theta

/ how to represent a binary outcome?
/ use sigmoid function

plt .ml.sigmoid .1*-50+til 100

/ classification
X:30+100*(100?1f;.01*til 100)
Y:enlist .ml.sigmoid .1*-150+sum X
plt X,Y

/ logistic regression cost
/ NOTE: accepts a list of thetas (in preparation for nn)
theta: (1;3)#0f;
.ml.logcost[X;Y;enlist theta]

/ logistic regression gradient
.ml.loggrad[X;Y;enlist theta]
/ iterate 100000 times
100000 .ml.gd[.0005;.ml.loggrad[X;Y]]/ enlist theta
/ iterate until cost is less than .5
(.5<.ml.logcost[X;Y]@) .ml.gd[.0005;.ml.loggrad[X;Y]]/ enlist theta
/ iterate until convergence
/.ml.gd[.0005;.ml.loggrad[X;Y]] over enlist theta

/ we can use qml and the just the cost function to compute gradient
/ and optimal step size

opts:`iter,1000,`full`quiet /`rk`slp`tol,1e-8
/ use cost function only
f:.ml.logcost[X;Y]enlist enlist@
.qml.minx[opts;f;theta]

/ or compute the result even faster with the most recent version of
/ qml, by passing the gradient function as well
f:(.ml.logcost[X;Y]enlist enlist@;raze .ml.loggrad[X;Y]enlist enlist@)
.qml.minx[opts;f;theta]

/ but the gradient often shares computations with the cost.  providing
/ a single function that calculates both and a better minimization
/ function makes finding the optimal parameters childs play
/ NOTE: use '\r' to show in-place updates to progress across iterations
theta:first .fmincg.fmincg[100;.ml.logcostgrad[X;Y];theta 0]

/ compare plots
.plot.plt X,Y
.plot.plt X,.ml.lpredict[X] enlist theta

/ digit recognition
/ multiple runs of logistic regression (one for each digit)

\cd /Users/nick/q/ml/mnist

/ load training data
Y:enlist y:"i"$ldidx read1 `$"train-labels-idx1-ubyte"
X:flip "f"$raze each ldidx read1 `$"train-images-idx3-ubyte"

/ visualize data
/ redefine plot (to include space)
plt:.plot.plot[55;28;.plot.c16] .plot.hmap flip 28 cut
plt  X[;rand til count X 0]

/ learn (one vs all)
lbls:til 10
lambda:1
theta:(1;1+count X)#0f
mf:(first .fmincg.fmincg[20;;theta 0]@) / pass minimization func as parameter
cgf:.ml.rlogcostgrad[lambda;X]          / cost gradient function

/ train one set of parameters for each number
/ NOTE: peach across digits
theta:.ml.onevsall[mf;cgf;Y;lbls]

100*avg y=p:.ml.predictonevsall[X] enlist theta / what percent did we get correct?

/ what did we get wrong?
p w:where not y=p
plt X[;i:rand w]
([]p;y) i

/ confirm analytic gradient is equal to numeric gradient
.ml.checknngradients[.1f;3 5 3]

/ learn (neural network with 1 hidden layer)
n:784 30 10
ymat:.ml.diag[last[n]#1f]@\:"i"$y

/ need random weights

theta:2 raze/ .ml.ninit'[-1_n;1_n];

/ batch gradient descent - steepest gradient (might find local minima)
first .fmincg.fmincg[10;.ml.nncost[0f;n;X;ymat];theta]

/ TODO fix `limit error
/.qml.minx[`quiet`full`iter,1;.ml.nncostf[0f;n;X;ymat];theta]

/ stochastic gradient descent -
/ - jumpy (can find global minima)
/ - converges faster (but might never stop)
/ on-line if n = 1
/ mini-batch if n>1 (vectorize calculations)

mf:{first .fmincg.fmincg[5;.ml.nncost[0f;n;X[;y];ymat[;y]];x]}

/https://www.quora.com/Whats-the-difference-between-gradient-descent-and-stochastic-gradient-descent
/ A: permutate, run n non-permuted epochs
i:{neg[x]?x} count X 0;X:X[;i];ymat:ymat[;i];Y:Y[;i];y:Y 0
theta:1 .ml.sgd[mf;til;10000;X]/ theta
/ B: run n permuted epochs
theta:1 .ml.sgd[mf;{neg[x]?x};10000;X]/ theta
/ C: run n random (with replacement)
theta:1 .ml.sgd[mf;{x?x};10000;X]/ theta

/ NOTE: can run any above example with cost threshold
theta:(1f<first .ml.nncost[0f;n;X;ymat]@) .ml.sgd[mf;{neg[x]?x};10000;X]/ theta

/ TIP: 3.4t {neg[x]?x} == 0N?x

/ what is the cost?
first .ml.nncost[0f;n;X;ymat;theta]

/ how well did we learn
100*avg y=p:.ml.predictonevsall[X] .ml.mcut[n] theta

/ visualize hidden features
plt 1_ first first .ml.mcut[n] theta

/ view a few mistakes
p w:where not y=p
plt X[;rw:rand w]
([]p;y) rw

/ load testing data
Yt:enlist yt:"i"$ldidx read1 `$"t10k-labels-idx1-ubyte"
Xt:flip "f"$raze each ldidx read1 `$"t10k-images-idx3-ubyte"

/ how well can we predict
100*avg yt=p:.ml.predictonevsall[Xt] .ml.mcut[n] theta

/ view a few mistakes
p w:where not yt=p
plt Xt[;rw:rand w]
([]p;yt) rw

/ k-means

/ redefine plot (to drop space)
plt:.plot.plot[55;28;1_.plot.c16]
k:3 / 3 centroids

show C:"f"$k?/:2#20 / initial centroids
X:raze each C,''C+bm(2;k)#100?/:(2*k)#1f
plt X

/ euler distance last elements starts as atom (specifying the number
/ of centroids) but becomes the actual centroids after the initial
/ iteration.
.ml.kmeans[X]\[k]

/ manhattan distance (taxicab metric)
/ NOTE: picks x and y from data (but not necessarily (x;y))
.ml.kmedians[X]\[k]

/ get http data from (h)ost with (l)ocaction
hget:{[h;l] (`$":http://",h)"GET ",l," HTTP/1.1\r\nHost:",h,"\r\n\r\n"}

/ classic machine learning iris data
s:hget["scipy-cookbook.readthedocs.io";"/_downloads/bezdekIris.data.txt"]
iris:flip `slength`swidth`plength`pwidth`species!("FFFFS";",") 0: -1_last "\r\n" vs s
X:value flip 4#/:iris
plt X 3
flip .ml.kmeans[X]/[3]

.ml.ecdist[X] .ml.kmeans[X]/[3]

/ TODO: kmeans to compress RGB, PCA for reduce dimensions

