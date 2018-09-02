\l funq/util.q
\l funq/ml.q
\l funq/svm.q

plt:.util.plot[50;20;.util.c16]
-1 "loading data set 1";
X:(2#"F";",")0:`:ex6data1X.txt
y:first Y:(1#"F";",")0:`:ex6data1y.txt
-1 "plotting data set";
-1 value plt X,Y;
-1 "defining svm problem";
prob:.svm.prob[X;y]
-1 "defining svm parameters";
param:.svm.defparam[prob;@[.svm.param;`kernel_type;:;.svm.LINEAR]]
param[`C]:1f
-1 "training";
m:.svm.train[prob;param]
-1 "determining accuracy";
avg y=p:.svm.predict[m;prob.x]
-1 "plotting points";
-1 value plt X,enlist p;
-1 "plotting surface";
-1 value plt Xm,enlist .svm.predict[m] .svm.sparse Xm:flip (cross) . X;

-1 "loading data set 2";
X:(2#"F";",")0:`:ex6data2X.txt
y:first Y:(1#"F";",")0:`:ex6data2y.txt
-1 "plotting data set";
-1 value plt X,Y;
-1 "defining svm problem";
prob:.svm.prob[X;y]
-1 "defining svm parameters";
param:.svm.defparam[prob;@[.svm.param;`kernel_type;:;.svm.RBF]]
param[`C`gamma]:(1f;200f)
-1 "training";
m:.svm.train[prob;param]
-1 "determining accuracy";
avg y=p:.svm.predict[m;prob.x]
-1 "plotting points";
-1 value plt X,enlist p;
-1 "plotting surface";
-1 value plt Xm,enlist .svm.predict[m] .svm.sparse Xm:flip (cross) . X;

-1 "loading data set 3";
X:(2#"F";",")0:`:ex6data3X.txt
y:first Y:(1#"F";",")0:`:ex6data3y.txt
-1 "plotting data set";
-1 value plt X,Y;
-1 "defining svm problem";
prob:.svm.prob[X;y]
-1 "defining svm parameters";
param:.svm.defparam[prob;@[.svm.param;`kernel_type;:;.svm.RBF]]
param[`C`gamma]:(1f;200f)
-1 "training";
m:.svm.train[prob;param]
-1 "determining accuracy";
avg y=p:.svm.predict[m;prob.x]
-1 "plotting points";
-1 value plt X,enlist p;
-1 "plotting surface";
-1 value plt Xm,enlist .svm.predict[m] .svm.sparse Xm:flip (cross) . X;

