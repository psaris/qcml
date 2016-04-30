\l /Users/nick/q/ml/plot.q

bmp:{[f;e;h;w]p 1: "BM";hclose (hopen[p]"i"$(54+4*h*w),0 54 40,h,w,(1+65536*32),0 0 1 1 0 0) e}
bmp:{[f;e]
 w:count e;h:count e 0;
 e:raze e;
 f 1: "BM";
 hclose (hopen[f]"i"$(54+4*count e),0 54 40,w,h,(1+65536*32),0 0 1 1 0 0) e;
 f}
\ 
w:1200;h:800
w:75;h:50
m: ([]x:0f;y:0f;n:0f;c:0e;cx:-2.25 + (5%w)*til w) cross ([]cy:-1.5f + (3%h)*til h)
/ n:norm, c:color
do [100;update x:cx+(x*x)-y*y,y:cy+2*x*y,n:(x*x)+y*y,c+1e from `m where n<4 ]
/k mandelbrot http://kparc.com/z/comp.k
\t +/~^+/b*b:49{c+(-/x*x;2**/x)}/c:-1.5 -1+(2*!2#w)%w:10

/ q
c:flip  (cross) . -2.5 -1.5+(til w;til h)%(w;h)%5 3
/ fix use of y
2 {n:sum y*y;x+((-/)y*y;2f*(*/)y)}[x]/0

/ k

k)b:4>@[n;&0n=n:+/ sqrt 50{c+(-/x*x;2*/x)}/c:+,/(-1.5+2*(!w)%w),/:\:-1+2*(!w)%w:200;:;4]
;`mandel.pbm 6:"P4\n",(5:2#w),"\n",_ci 2_sv'-1 8#,/+(2#w)#b

k)b:4>0w^sum sqrt 10{c+(-/x*x;2*/x)}/c:+,/(-1.5+2*(!w)%w),/:\:-1+2*(!w)%w:200

c:flip raze (-2+3*( til w)%w),/:\:-1.5+3*(til w)%w:2000
c:flip raze (-2+4*( til w)%w),/:\:-2+4*(til w)%w:2000
b:4>0w^sum 100{c+((-/)x*x;2f*(*/)x)}/c
/b:sum 4>0w^sum each 50{c+((-/)x*x;2f*(*/)x)}\c
b:last 100{n+((-/)i2;2f*(*/)i;x[2]+4f>0w^(+/)i2:i*i:2#x)}/n:c,(1;count c 0)#0
\c 100 200
plt .plot.hmap w cut  b
bmp[`:/Users/nick/q/ml/red.bmp] flip w cut "e"$b
/k)`mandel.pbm 6:"P4\n",(5:2#w),"\n",_ci 2_sv'-1 8#,/+(2#w)#b


plt:.plot.plot[50;25;.plot.c10]
plt:.plot.plot[50;25;.plot.c16]
plt:.plot.plot[50;25;.plot.c68]
plt:.plot.plot[200;100;.plot.c89]
\c 80 100
plt .plot.hmap w cut m.c
bmp [ p:`:/Users/nick/q/ml/red.bmp; e:m.c; h;w ]
