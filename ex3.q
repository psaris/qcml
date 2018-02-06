\l /Users/nick/q/funq/util.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q
\l /Users/nick/q/funq/qmlmm.q
\l /Users/nick/q/funq/fmincg.q

\
\cd /Users/nick/Downloads/machine-learning-ex3/ex3
X:(400#"F";",")0:`:ex3data1.csv / 5000 20x20 bitmaps
y:first Y:(1#"F";",")0:`:ex3data2.csv  / integers 1-10 (10=0)

/ plot 4 random bitmaps
plt:.util.plot[20;10;.util.c16] .util.hmap 20 cut
-1 value (,') over  plt each flip X[;-4?til count X 0];

lbls:"f"$1+til 10
lambda:1
THETA:(1;1+count X)#0f

/ using fmincg
mf:(first .fmincg.fmincg[20;;THETA 0]@) / pass min func projection as parameter
cgf:.ml.rlogcostgrad[lambda;X] / cost gradient function

/ using qml.minx
mf:{first .qml.minx[`quiet`full`iter,20;x;THETA]`last}
cgf:.ml.rlogcostgradf[lambda;X]

THETA:.ml.onevsall[mf;cgf;Y;lbls] / train one set of parameters for each number
100*avg y=lbls .ml.predictonevsall[X] enlist THETA / what percent did we get correct?
/ mistakes
w:-4?where not y=p:lbls .ml.predictonevsall[X] enlist THETA / what percent did we get correct?
-1 value (,') over plt each flip X[;w];
show flip([]p;y) w

/ confusion matrix
show .ml.cm[y;p]
