\l /Users/nick/q/funq/util.q
\l /Users/nick/q/funq/ml.q
\l /Users/nick/q/qml/src/qml.q
\l /Users/nick/q/funq/qmlmm.q
\l /Users/nick/q/funq/svm.q

\
\cd /Users/nick/Downloads/machine-learning-ex6/ex6

/ dataset 1
plt:.util.plot[50;20;.util.c16]
X:(2#"F";",")0:`:ex6data1X.csv
y:first Y:(1#"F";",")0:`:ex6data1y.csv
plt X,Y
prob:.svm.prob[X;y]
param:.svm.defparam[prob;@[.svm.param;`kernel_type;:;.svm.LINEAR]]
param[`C]:1f
m:.svm.train[prob;param]
avg y=.svm.predict[m;prob.x]
plt X,enlist .svm.predict[m;prob.x]
plt Xm,enlist .svm.predict[m] .svm.sparse Xm:flip (cross) . X

/ dataset 2
X:(2#"F";",")0:`:ex6data2X.csv
y:first Y:(1#"F";",")0:`:ex6data2y.csv
plt X,Y
prob:.svm.prob[X;y]
param:.svm.defparam[prob;@[.svm.param;`kernel_type;:;.svm.RBF]]
param[`C`gamma]:(1f;200f)
m:.svm.train[prob;param]
avg y=.svm.predict[m;prob.x]
plt X,enlist .svm.predict[m;prob.x]
plt Xm,enlist .svm.predict[m] .svm.sparse Xm:flip (cross) . X

/ dataset 3
X:(2#"F";",")0:`:ex6data3X.csv
y:first Y:(1#"F";",")0:`:ex6data3y.csv
plt X,Y
prob:.svm.prob[X;y]
param:.svm.defparam[prob;@[.svm.param;`kernel_type;:;.svm.RBF]]
param[`C`gamma]:(1f;200f)
m:.svm.train[prob;param]
avg y=.svm.predict[m;prob.x]
plt X,enlist .svm.predict[m;prob.x]
plt Xm,enlist .svm.predict[m] .svm.sparse Xm:flip (cross) . X

