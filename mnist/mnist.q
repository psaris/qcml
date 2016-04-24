\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/ml/fmincg.q

/ christian langreiter's
k)shape:{y{y#x}/0N,'|1_x}
/ mine
k)shape:{((*/x)#y){y#x}/0N,'|1_x,()}

ldidx:{
 d:first (1#4;1#"i") 1: 4_(h:4*1+x 3)#x;
 x:first ((1 1 0N 2 4 4 8;"xx hief")@\:(),x[2]-0x08) 1: h _x;
 x:((prd[d])#x){y cut x}/reverse 1_d;
 x}

\
\cd /Users/nick/q/ml/mnist
\l /Users/nick/q/qtips/prof.q
\l /Users/nick/q/qtips/util.q
.prof.instrall`
/ load training data

y:"i"$ldidx read1 `$"train-labels-idx1-ubyte"
X:flip "f"$raze each ldidx read1 `$"train-images-idx3-ubyte"
plt:.plot.plot[55;28;.plot.c10] .plot.hmap flip 28 cut
plt:.plot.plot[55;28;.plot.c16] .plot.hmap flip 28 cut
plt:.plot.plot[55;28;.plot.c68] .plot.hmap flip 28 cut
\c 100 100
plt  X[;i:rand til count X 0]
plt  X[;i]

/ learn
n:784 30 10;
ymat:.ml.diag[last[n]#1f]@\:"i"$y
theta:2 raze/ .ml.rweights'[-1_n;1_n];
/ batch gradient descent
theta:first .fmincg.fmincg[1;.ml.nncost[X;ymat;0;n];theta]
/ stochastic gradient descent
theta:{[X;ymat;theta;i]first .fmincg.fmincg[1;.ml.nncost[X[;i];ymat[;i];0;n];theta]}[X;ymat]/[theta;10 cut {neg[x]?x} count first X]

/ how well did we learn
100*avg y=.ml.predictonevsall[X].ml.unraze[n] theta
\c 200 400
p w:where not y=p:.ml.predictonevsall[X].ml.unraze[n] theta
(,') over plt each 4#flip X[;w]
`p`a!(p 4#w;y 4#w)

/ load testing data
yt:"i"$ldidx read1 `$"t10k-labels-idx1-ubyte"
Xt:flip "f"$raze each ldidx read1 `$"t10k-images-idx3-ubyte"

/ how well can we predict
100*avg yt=.ml.predictonevsall[Xt].ml.unraze[n] theta

(,') over plt each 4#flip Xt[;w]
`p`a!(p 4#w;yt 4#w)
