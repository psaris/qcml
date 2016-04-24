\l /Users/nick/q/ml/plot.q
\l /Users/nick/q/ml/ml.q
\l /Users/nick/q/ml/fmincg.q
\l /Users/nick/q/qml/src/qml.q

\
\cd /Users/nick/Downloads/machine-learning-ex3/ex3
X:(400#"F";",")0:`:ex3data1.csv / 5000 20x20 bitmaps
y:(1#"F";",")0:`:ex3data2.csv  / integers 1-10 (10=0)

/ plot 4 random bitmaps
plt:(.plot.plot[20;20;.plot.c16] .plot.hmap 20 cut)
(,') over  plt each flip X[;-4?til count X 0]

nlbls:10
lambda:1
theta:.ml.onevsall[200;X;y;nlbls;lambda] / train one set of parameters for each number
100*avg first[y]=1+.ml.predictonevsall[X] enlist theta / what percent did we get correct?

/ mistakes
w:-4?where not first[y]=p:1+.ml.predictonevsall[X] enlist theta / what percent did we get correct?
(,') over plt each flip X[;w]
`p`a!(p w;first[y] w)
