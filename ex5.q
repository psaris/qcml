\l /Users/nick/q/funq/plot.q
\l /Users/nick/q/funq/fmincg.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q
\l /Users/nick/q/funq/qmlmm.q

\
\cd /Users/nick/Downloads/machine-learning-ex5/ex5
plt:.plot.plot[23;12;1_.plot.c16]
data:(2#"F";",")0:`:ex5data1.csv
plt data
X:1#data
Y:-1#data
THETA:(1;1+count X)#1f

303.99319222026429 ~ .ml.rlincost[1f;X;Y;THETA]
-15.303015674201186 598.25074417270355 ~ first .ml.rlingrad[1f;X;Y;THETA]