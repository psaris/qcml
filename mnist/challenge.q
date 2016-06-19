

k)shape:{((*/x)#y){y#x}/0N,'|1_x,()}

k)shape:{y{y#x}/|1_+(:':*\x;x)}
k)shape:{y{y#x}/|+(-1_*\x;1_x)}
k)shape:{y{y#x}/|(-1_*\x),'1_x}

shape:{(prd[x]#y){y cut x}/reverse 1_x,()}
shape[2 3 4;til 100]

winghang:{
 d:last(1#4;1#"i")1:x i:4+til 4*x 3;
 if[all 0=d;:0x];
 f:$[8=t:x 2;::;{last(1#2 4 4 8 x;1#"hief"x)1:y}t-0x0b];
 x:f(1+last i)_x;
 x:(prd[d]#x){y cut x}/reverse 1_d;
 x}
flip[enlist (4;"i")]
(1#4;1#"i")

k)olegfinkelshteyn:{(*(,4;,"i")1:(4*d)#4_x)#*(,:'(1 1 0 2 4 4 8;"xx hief")@\:-8+x 2)1:(4+4*d:x 3)_x}
k)olegfinkelshteyn:{{$[2<#x;h#.z.s[(*/h:2#x),2_x;y];x#y]}/*:'(,:''(1 1 0 2 4 4 8;"xx hief")@\:/:4,-8+x 2)1:'(4,4+4*x 3)_x}


fastest:{
 d:first (1#4;1#"i") 1: 4_(h:4*1+x 3)#x;
/ x:first ((1 1 0N 2 4 4 8;"xx hief")@\:(),x[2]-0x08) 1: h _x;
 x:$[0>i:x[2]-0x0b;::;first ((2 4 4 8;"hief")@\:i,()) 1:] h _x;
 x:((prd[d])#x){y cut x}/reverse 1_d;
/ x:d#x;
 x}@

kdb34:{
 d:first (1#4;1#"i") 1: 4_(h:4*1+x 3)#x;
 x:d#$[0>i:x[2]-0x0b;::;first ((2 4 4 8;"hief")@\:i,()) 1:] h _x;
 x}@

k)pierre:{{y{y#x}/|+(-1_*\x;1_x)}/{*(+,(-9+#-8!x$0;x:.Q.t(x>12)+4|x-6))1:y}'[12,x 2;(4,4*1+x 3)_x]}

fastest:{
 {d:first (1#4;1#"i") 1: 4_(h:4*1+x 3)#x;
 x:first ((1 1 0N 2 4 4 8;"xx hief")@\:(),x[2]-0x08) 1: h _x;
/ x:$[0>i:x[2]-0x0b;::;first ((2 4 4 8;"hief")@\:i,()) 1:] h _x;
 x:((prd[d])#x){y cut x}/reverse 1_d;
/ x:d#x;
 x}x}


/attila:{(0x0 sv'0N 4#x 4+til 4*x 3)#first(1 2 4 4 8;"xhief")[;enlist 0|-10+x 2]1:(4*1+x 3)_ x}
attilavrabecz:{(0x0 sv'0N 4#x 4+(!)n)#first(1 2 4 4 8;"xhief")[;enlist 0|x[2]-10]1:(4+n:4*x 3)_ x}
attilavrabecz:{{(prd[x]#y){y#x}/0Ni,'reverse 1_x}[0x0 sv'0N 4#x 4+til 4*x 3;first(1 2 4 4 8;"xhief")[;enlist 0|-10+x 2]1:(4*1+x 3)_ x]}
attilavrabecz:{{(prd[x]#y){y#x}/0Ni,'reverse 1_x}[0x0 sv'0N 4#x 4+til 4*x 3;first(1 2 4 4 8;"xhief")[;enlist 0|-10+x 2]1:(4*1+x 3)_ x]}@

k)ryansparks:{(0x0/:'(0N 4)#(d*4)#4_x)#*(1#'(0x08090b0c0d0e!1 1 2 4 4 8,'"xxhief")x 2)1:(4*1+d:"i"$x 3)_x}
k)ryansparks:{{$[x>-2+#y;z;.z.s[x+1;y]'(y[x],(|*\|y)@x+1)#z]}[0;0x0/:'0N 4#(d*4)#4_x;*(1#'(1,"x")^(2 4 4 8,'"hief")@-11+"i"$x 2)1:(4*1+d:"i"$x 3)_x]}


k)jamescoakley:{
    r:"j"$x 3;
    t:([8 9 11 12 13 14]c:"xxhief";s:1 1 2 4 4 8)"j"$x 2;
    l:*(,4;,"i")1:(r*4)#4_x;
    p:*(,t`s;,t`c)1:((t`s)*/l)#(4+r*4)_x;
    p{.q.cut[y]x}/|1_l}

joellemay:{[x]
	convertInt:{0x0 sv x};

	//
	// Parse magic number.
	//
	$[(x[2]=0x08)|x[2]=0x09;[t:4h;convert:(::);size:1];
		$[x[2]=0x0B;[t:5h;convert:{0x0 sv x};size:2];
		$[x[2]=0x0C;[t:6h;convert:convertInt;size:4];
		$[x[2]=0x0D;[t:8h;convert:{raze(enlist 4;enlist"e")1:x};size:4];
		[t:9h;convert:{raze(enlist 8;enlist"f")1:x};size:8]]]]];
	dim:6h$x 3;
	
	//
	// Number of items.
	//
	num:convertInt x 4+til 4;
	
	//
	// Get image resolution.
	//
	res:$[dim-:1;convertInt each 4 cut x 8+til 4*dim;()];

	//
	// Cut list accordingly.
	//
	t${y cut x}/[raze convert each size cut *[$[dim;(*/)res;1];size*num]#(8+4*dim)_x;res]
 };

maratkhalitov:{[x]
	r:(2 1 1 4;" xxi") 1: 8#x;
	f:first r[0];
	if[f~0x08;t:"x";l:1];
	if[f~0x09;t:"x";l:1];
	if[f~0x0B;t:"h";l:2];
	if[f~0x0C;t:"i";l:4];
	if[f~0x0D;t:"e";l:4];
	if[f~0x0E;t:"f";l:8];
	
	D:first r[1];
	I:first r[2];
	if[I~0i;:t$()];

	x:8_x;
	if[D~0x01;:first (enlist l;enlist t) 1: (I*l)#x];

	if[D~0x02;
			I1:first first (enlist 4;enlist "i") 1: 4#x;
			x:4_x;
			R:first (enlist l;enlist t) 1: (I1*I*l)#x;
			R1:(I1,I)#R;
			:R1;
			];

	if[D~0x03;
			I1:first first (enlist 4;enlist "i") 1: 4#x;
			x:4_x;
			I2:first first (enlist 4;enlist "i") 1: 4#x;
			x:4_x;		
			R:first (enlist l;enlist t) 1: x;
			L:I2*I1*l;
			:((I2,I1)#)'[I#(((I2*I1)+)\[`long$I;0]) _ x];
			];
	}


martakhalitov:{[x]
	r:(2 1 1 4;" xxi") 1: 8#x;
	f:first r[0];
	if[f~0x08;t:"x";l:1];
	if[f~0x09;t:"x";l:1];
	if[f~0x0B;t:"h";l:2];
	if[f~0x0C;t:"i";l:4];
	if[f~0x0D;t:"e";l:4];
	if[f~0x0E;t:"f";l:8];
	
	D:first r[1];
	I:first r[2];
	if[I~0i;:t$()];

	x:8_x;
	if[D~0x01;:first (enlist l;enlist t) 1: (I*l)#x];

	if[D~0x02;
			I1:first first (enlist 4;enlist "i") 1: 4#x;
			x:4_x;
			R:first (enlist l;enlist t) 1: (I1*I*l)#x;
			R1:(I1,I)#R;
			:R1;
			];

	if[D~0x03;
			I1:first first (enlist 4;enlist "i") 1: 4#x;
			x:4_x;
			I2:first first (enlist 4;enlist "i") 1: 4#x;
			x:4_x;		
			R:first (enlist l;enlist t) 1: x;
			L:I2*I1*l;
			:((I2,I1)#)'[I#(((I2*I1)+)\[`long$I;0]) _ x];
			];
	}

k)maratkhalitov:{
 r:,/(2 1 1 4;" xxi")1:8#x;
 f:([f:0x08090B0C0D0E]t:"xxhief";l:1 1 2 4 4 8)@r 0;
 x:8_x;
 $[0i~I:r 2;:(f`t)$();
  0x1~r 1;:((,f`l;,f`t)1:(I*f`l)#x)0;
  0x2~r 1;[M:((,4;,"i")1:4#x)[0;0];R:((,f`l;,f`t)1:(M*I*f`l)#x:4_x)0;:(M,I)#R]];
 O:,/(4 4;"ii")1:8#x;
 (O#)'[I#((+[prd O])\[7h$I;0])_x:8_x]}

alexbelopolsky:{
  mcut:{$[(n:count x)=1;y;n=2;x#y;.z.s[x]each(prd x:1_x)cut y]};
  T:0x08090B0C0D0E!flip(1 1 2 4 4 8;"xxhief");
  cast:{$[last[x]="x";y;first(enlist each x)1:y]};
  t:T x 2;
  n:"j"$x 3;
  s:first(enlist 4;enlist"i")1:(4;4*n)sublist x;
  d:(4+4*n;first[t]*prd s)sublist x;
 mcut[s]cast[t]d}

alexbelopolsky:{C:{first(enlist each x)1:y};
 s:C[(4;"i")]x 4+til 4*n:x 3;
 d:(4+4*n)_x;t:x 2;
 if[t>9;d:C[(0x0B0C0D0E!flip(2 4 4 8;"hief"))t]d];
 $[n=1;d;n=2;s#d;{x[y+z]}[d;r#til k]each(k:prd r:1_s)*til first s]}


aarondavies:{{
 t:(0x08090b0c0d0e!4 4 5 6 8 9h)x 2;
 s:(4 5 6 8 9h!1 2 4 4 8)t;
 d:x 3;
 n:0x0 sv'4 cut x 4+til d*4;
 p:(4 5 6 8 9h!(::;0x0 sv;0x0
 sv;-9!0x010000000d000000f8,reverse@;-9!0x0100000011000000f7,reverse@))t;
 $[count p each a:$[4h=t;::;s cut](s*prd n)#(4*1+d)_x;first(p each
    a){y cut x}/reverse n;a]}x}

aarondavies:{{s:(4 5 6 8 9h!1 2 4 4 8)t:(0x08090b0c0d0e!4 4 5 6 8 9h)x 2;
 p:(4 5 6 8 9h!(::;0x0 sv;0x0 sv;-9!0x010000000d000000f8,reverse@;-9!0x0100000011000000f7,reverse@))t;
 $[count b:p each a:$[4h=t;::;s cut](s*prd n:0x0 sv'4 cut x 4+til d*4)#(4*1+d:x 3)_x;first b{y cut x}/reverse n;a]}x}

johngleeson:{	
	m:4#x; d:4_x;
	v:("xxhief"!1 1 2 4 4 8)t:(0x08090B0C0D0E!"xxhief")m 2;
	c:(*/)i:raze(s#/:(4;"i"))1:(4*s:"i"$m 3)#d;
	d:(c*v)#(s*4)_d;
	d:$[t~"x";d;(c#/:(v;t))1:d];
	$[1=count i;raze d;{cut[y;x]}/[d;1_i]]
 };


k),/3 *[2]\1 1

k)ldidx:{(0x0/:'0N 4#4_h#x)#*((,/3(2*)\1 1;"xx hief")@\:,x[2]-8)1:(h:4*1+x 3)_x}
/byte vector: 04
/short vector: 05
/int vector: 06
/long vector: 07
/real vector: 08
/float vector: 09
k)ldidx:{(0x0/:'0N 4#4_h#x)#-9!0N!0x00000000,(0x0\:"i"$8+#n),n:("x"$4|(x[2]-6)),0x00,(0x0\:"i"$(#x)-h),(h:4*1+x 3)_x}

a1:ldidx x



k)ldidx:{(*(+,4,"i")1:4_h#x)#*((,/3(2*)\1 1;"xx hief")@\:,x[2]-8)1:(h:4*1+x 3)_x}
k)ldidx:{#/*+(+(9\:592316;"xxThief")@\:+,4,-8+x 2)1:'(0,4*x 3)_4_x}/ piere
k)ldidx:{(*(+,(4;"i"))1:4_h#x)#*((1 1 2 2 4 4 8;"xx hief")@\:,x[2]-8)1:(h:4*1+x 3)_x}
count 2_last get ldidx
check[b] `ldidx


check:{[b;f]
 -1"runing unit tests for ", fs:string f;
 if[not (`byte$())~f 0x0000080100000000;'`empty];
 if[not enlist[0x00]~f 0x000008010000000100;'`1d];
 if[not (0x0001;0x0203)~f 0x0000080200000002000000020001020304;'`2d];
 if[not ((0x0001;0x0203);(0x0405;0x0607))~f 0x00000803000000020000000200000002000102030405060708;'`3d];
 if[not 1 2h~f 0x00000B010000000200010002;'`short];
 if[not 1 2i~f 0x00000C01000000020000000100000002;'`int];
 if[not 1 2e~f 0x00000D01000000023f80000040000000;'`real];
 if[not 1 2f~f 0x00000E01000000023ff00000000000004000000000000000;'`float];
 -1"checking md5 of function output";
 if[not 0x6a5cde79f049959f93df34292c599c1b~md5 raze over string f b;'`md5];
 -1"running performance tests";
 r:0N!`n`ms`bytes!count[first get get f],system"ts:10 ", fs, " b";
 r}

\

\cd /Users/nick/q/ml/mnist
b:read1 `$"train-images-idx3-ubyte"
X:ldidx b

check[b] `fastest
check[b] `kdb34
check[b] `attilavrabecz
check[b] `ryansparks
check[b] `maratkhalitov
check[b] `pierre
check[b] `olegfinkelshteyn
check[b] `johngleeson
check[b] `fastest

f:`fastest`shortest`winghang
f:`attilavrabecz`maratkhalitov
f:`ryansparks`jamescoakley`joellemay
f:`alexbelopolsky`aarondavies
f,:`olegfinkelshteyn
r:check[b] each ([]func:f)!f

r:1!flip `name`n`ms`bytes!"sjjj"$\:()
r,:`name`n`ms`bytes!`attilavrabecz,1 12158 199795120
r,:`name`n`ms`bytes!`ryansparks,57 26941 244273792
r,:`name`n`ms`bytes!`jamescoakley,104 13672 199795168
r,:`name`n`ms`bytes!`joellemay,193 169140 2377695840
r,:`name`n`ms`bytes!`maratkhalitov,200 4074 244273680
r,:`name`n`ms`bytes!`alexbelopolsky,91 18525 1073742800
r,:`name`n`ms`bytes!`aarondavies,5 48820 1155293536
/r,:`name`n`ms`bytes!`pierrekovalev,25 14636 190960016
r,:`name`n`ms`bytes!`johngleeson,116 3782 199795088
r,:`name`n`ms`bytes!`fastestest,1 3156 199795056

`pts xdesc `bytes`ms`n xasc update "i"$ms*.1, pts:sum {x=min x} each(n;ms;bytes) from r
