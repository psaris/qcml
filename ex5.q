\l funq.q

plt:.util.plot[23;12;.util.c16]
-1 "loading data set";
data:(2#"F";",")0:`:ex5data1.txt
-1 "plotting data";
-1 value plt data;
X:1#data
Y:-1#data
THETA:(1;1+count X)#1f

-1 "confirming cost and gradient calculations";
.util.assert[303.99319222026429] .ml.rlincost[0f;1f;X;Y;THETA]
.util.assert[-15.303015674201186 598.25074417270355] first .ml.rlingrad[0f;1f;X;Y;THETA]
