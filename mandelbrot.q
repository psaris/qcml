\l /Users/nick/q/funq/plot.q
\l /Users/nick/q/funq/util.q

\
/k mandelbrot http://kparc.com/z/comp.k
\t +/~^+/b*b:49{c+(-/x*x;2**/x)}/c:-1.5 -1+(2*!2#w)%w:10
/ q
/ k3
k)b:4>@[n;&0n=n:+/ sqrt 50{c+(-/x*x;2*/x)}/c:+,/(-1.5+2*(!w)%w),/:\:-1+2*(!w)%w:200;:;4]
 ;`mandel.pbm 0:"P4\n",(5 2#w),"\n",_ci 2_sv'-1 8#,/+(2#w)#b
/k 4
k)b:4>0w^sum sqrt 10{c+(-/x*x;2*/x)}/c:+,/(-1.5+2*(!w)%w),/:\:-1+2*(!w)%w:200

/ coordinates
/c:flip raze (-2+3*( til w)%w),/:\:-1.5+3*(til w)%w:2000
c:flip raze (-2+4*( til w)%w),/:\:-2+4*(til w)%w:1000
/ bits
b:4>0w^sum 20{c+((-/)x*x;2f*(*/)x)}/c
/ gray scale
b:last 30{n+((-/)i2;2f*(*/)i;x[2]+4f>0w^(+/)i2:i*i:2#x)}/n:c,(1;count c 0)#0
\c 100 200
value .plot.plt .plot.hmap w cut  b
`:/Users/nick/q/ml/mandel.pgm 0:  .util.pgm w cut b
`:/Users/nick/q/ml/mandel.pbm 0:  .util.pbm 20<w cut b
