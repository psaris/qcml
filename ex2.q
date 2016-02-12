\l /Users/nick/q/plot.q
\l /Users/nick/q/qml/src/qml.q

/ ex 2

sigmoid:{1f%1f+exp neg x}
/ logistic regression cost
err:()
/lrcost:{[X;y;theta]:[;f]`err upsert f: (-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:sigmoid flip[X]$theta}
lrcost:{[X;y;theta](-1f%count y)*sum (y*log x)+(1f-y)*log 1f-x:sigmoid X$theta}
lrgrad:{[X;y;theta](1f%count y)*flip[X]$sigmoid[X$theta]-y}

data:flip ("FFF";",")0:`$":/Users/nick/Downloads/machine-learning-ex2/ex2/ex2data1.txt"
X:1f,'data[;0 1]
y:data[;2]
theta:count[first X]#0f
lrcost[X;y;theta]
lrgrad[X;y;theta]
opts:`iter,7000,`full`quiet
opts:`iter,7000,`full`quiet`rk
opts:`iter,3,`full`quiet`slp
a:.qml.minx[;lrcost[X;y];enlist theta] each flip (`iter;600*1+til 10;`full;`quiet;`rk)

opts:`iter,7000,`full`quiet
.qml.minx[opts;lrcost[X;y];enlist theta]
.qml.minx[opts][(lrcost[X;y]@;enlist lrgrad[X;y]@);enlist theta]


