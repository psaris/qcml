\l /Users/nick/q/funq/util.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q
\l /Users/nick/q/funq/qmlmm.q
\l /Users/nick/q/funq/fmincg.q

\cd /Users/nick/Downloads/machine-learning-ex5/ex5
plt:.util.plot[23;12;.util.c16]
data:(2#"F";",")0:`:ex5data1.csv
-1 value plt data;
X:1#data
Y:-1#data
THETA:(1;1+count X)#1f

.util.assert[303.99319222026429] .ml.rlincost[1f;X;Y;THETA]
.util.assert[-15.303015674201186 598.25074417270355] first .ml.rlingrad[1f;X;Y;THETA]