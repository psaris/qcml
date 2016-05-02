\cd /Users/nick/q/qtips
\l /Users/nick/q/qtips/qtips.q
\l /Users/nick/q/ml/mnist/mnist.q
\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q
\c 40 80

/ define a plotting function
plt:.plot.plot[49;25;1_.plot.c16]

/ plot sin x
plt sin .01*til 1000

/ uniform random variables
plt 100000?1f

/ normal random variables (k6:10000?-1f)
plt .stat.bm 10000?1f

/ 2 sets of independant normal random variables
/ NOTE: matrix variables are uppercase
X:(.stat.bm 10000?) each 1 1f

/ plot x,y
plt X

/ correlate x and y
rho:.8
X[0]:(rho;sqrt 1-rho*rho)$X

/ NOTE: supress the desire to flip matrices. Matlab/Octave/R all have
/ store data in columns q needs the ability to tag matrices so they
/ can be displayed (not stored) flipped
flip X

/ plot correlated x,y
plt X

/ fit a line with intercept
Y:-1#X
X:1#X
Y lsq .ml.addint X

/ fast but not numerically stable
.ml.mlsq

/ NOTE: use 'X$/:Y' instead of 'Y mmu flip X' so we don't have to flip
/ large matrices
Y mmu flip X
X$/:Y

/ nice to have closed form solution, but what if we don't?

/ gradient descent
alpha:.1
theta:1 2#0f
/ n steps
10 .ml.gd[alpha;.ml.lingrad[X;Y]]/ theta
/ until convergence
.ml.gd[alpha;.ml.lingrad[X;Y]] over theta

/ how to represent a binary outcome?
/ use sigmoid function

plt .ml.sigmoid .1*-50+til 100

X:30+100*(100?1f;.01*til 100)
Y:enlist .ml.sigmoid .1*-150+sum X
plt X,Y

/ logistic regression cost
/ NOTE: accepts a list of thetas
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

/ rk:runge–kutta, slp: success linear programming
opts:`iter,1000,`full`quiet
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
plt:.plot.plot[55;28;.plot.c16] .plot.hmap flip 28 cut

\
/ load training data
Y:enlist y:"i"$ldidx read1 `$"train-labels-idx1-ubyte"
X:flip "f"$raze each ldidx read1 `$"train-images-idx3-ubyte"

/ visualize data
plt  X[;i:rand til count X 0]
plt  X[;i]

/ learn (one vs all)
nlbls:10
lambda:1
theta:.ml.onevsall[20;X;Y;nlbls;lambda] / train one set of parameters for each number
/ NOTE: peach across digits
100*avg y=p:1+.ml.predictonevsall[X] enlist theta / what percent did we get correct?

p w:-4?where not y=p
(,') over plt each flip X[;w]
`p`a!(p w;y w)

/ learn (neural network with 1 hidden layer)
n:784 30 10;
ymat:.ml.diag[last[n]#1f]@\:"i"$y
/ randomize weights to break symmetry and improve chances of finding a
/ global minimum
theta:2 raze/ .ml.rweights'[-1_n;1_n];
/ batch gradient descent
first .fmincg.fmincg[5;.ml.nncost[X;ymat;0;n];theta]

/ stochastic gradient descent
sgd:{[m;X;ymat;l;n;theta;i]first .fmincg.fmincg[m;.ml.nncost[X[;i];ymat[;i];l;n];theta]}
theta:sgd[5;X;ymat;0f;n]/[theta;10000 cut {neg[x]?x} count first X]

/ how well did we learn
100*avg y=p:.ml.predictonevsall[X].ml.unraze[n] theta

p w:-4?where not y=p
(,') over plt each 4#flip X[;w]
`p`a!(p w;y w)

/ load testing data
Yt:enlist yt:"i"$ldidx read1 `$"t10k-labels-idx1-ubyte"
Xt:flip "f"$raze each ldidx read1 `$"t10k-images-idx3-ubyte"

/ how well can we predict
100*avg yt=p:.ml.predictonevsall[Xt].ml.unraze[n] theta

p w:-4?where not yt=p
(,') over plt each 4#flip Xt[;w]
`p`a!(p 4#w;yt 4#w)

