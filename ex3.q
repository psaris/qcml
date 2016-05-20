\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

\
\cd /Users/nick/Downloads/machine-learning-ex3/ex3
X:(400#"F";",")0:`:ex3data1.csv / 5000 20x20 bitmaps
Y:(1#"F";",")0:`:ex3data2.csv  / integers 1-10 (10=0)

/ plot 4 random bitmaps
plt:(.plot.plot[20;20;.plot.c16] .plot.hmap 20 cut)
(,') over  plt each flip X[;-4?til count X 0]

lbls:1+til 10
lambda:1
THETA:(1;1+count X)#0f

/ using fmincg
mf:(first .fmincg.fmincg[200;;THETA 0]@) / pass min func projection as parameter
cgf:.ml.rlogcostgrad[lambda;X] / cost gradient function

/ using qml.minx
mf:{first .qml.minx[`quiet`full`iter,20;x;THETA]`last}
cgf:.ml.rlogcostgradf[lambda;X]

THETA:.ml.onevsall[mf;cgf;Y;lbls] / train one set of parameters for each number
100*avg first[Y]=lbls .ml.predictonevsall[X] enlist THETA / what percent did we get correct?
/ mistakes
w:-4?where not first[Y]=p:lbls .ml.predictonevsall[X] enlist THETA / what percent did we get correct?
(,') over plt each flip X[;w]
flip([]p;first[Y]) w
