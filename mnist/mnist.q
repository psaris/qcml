\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ex4.q
\l /Users/nick/q/ml/fmincg.q

shape:{(prd[x]#y) {y cut x}/ reverse 1_x}

ldidx:{[f]
 if[not 0x0000~2#b:read1 f;'`badmsg];
 m:0x08090B0C0D0E!flip (1 1 2 4 4 8;"xxhief");
 n:first (1#4;1#"i") 1: 4_(h:4+4*b 3)#b;
 x:first (1#/:m b 2) 1:h _b;
 x:x {y cut x}/ reverse 1_n; / why can't # > 2
 x}

\
\cd /Users/nick/q/ml/mnist
\l /Users/nick/q/qtips/prof.q
\l /Users/nick/q/qtips/util.q
.prof.instrall`
/ load training data
y:"i"$ldidx `$"train-labels-idx1-ubyte"
X:flip "f"$raze each ldidx `$"train-images-idx3-ubyte"
plt:.plot.plot[20;10;" ",.plot.c] .plot.hmap flip 28 cut
(,') over plt each  flip X[;-4?til count X 0]

/ learn
n:784 30 10;
ymat:diag[last[n]#1f]@\:"i"$y
theta:2 raze/ rweights'[-1_n;1_n];
/ batch gradient descent
theta:first .fmincg.fmincg[5;nncost[X;ymat;0;n];theta]

/ stochastic gradient descent
theta:{[X;ymat;theta;i]first .fmincg.fmincg[1;nncost[X[;i];ymat[;i];0;n];theta i]}[X;ymat]/[1000 cut til count theta]

/ how well did we learn
100*avg y=predictonevsall[X]unraze[n] theta

p w:where not y=p:predictonevsall[X]unraze[n] theta
(,') over plt each 4#flip X[;w]
`p`a!(p 4#w;y 4#w)

/ load testing data
yt:"i"$ldidx `$"t10k-labels-idx1-ubyte"
Xt:flip "f"$raze each ldidx `$"t10k-images-idx3-ubyte"

/ how well can we predict
100*avg yt=predictonevsall[Xt]unraze[n] theta

(,') over plt each 4#flip Xt[;w]
`p`a!(p 4#w;yt 4#w)
