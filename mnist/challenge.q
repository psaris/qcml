

k)shape:{((*/x)#y){y#x}/0N,'|1_x,()}
shape:{(prd[x]#y){y cut x}/reverse 1_x,()}

winghang:{
 d:last(1#4;1#"i")1:x i:4+til 4*x 3;
 if[all 0=d;:0x];
 f:$[8=t:x 2;::;{last(1#2 4 4 8 x;1#"hief"x)1:y}t-0x0b];
 x:f(1+last i)_x;
 x:(prd[d]#x){y cut x}/reverse 1_d;
 x}

fastest:{
 d:first (1#4;1#"i") 1: 4_(h:4*1+x 3)#x;
 x:first ((1 1 0N 2 4 4 8;"xx hief")@\:(),x[2]-0x08) 1: h _x;
/ x:$[0>i:x[2]-0x0b;::;first ((2 4 4 8;"hief")@\:i,()) 1:] h _x;
 x:((prd[d])#x){y cut x}/reverse 1_d;
/ x:d#x;
 x}

shortest:{(first flip[enlist (4;"i")] 1: 4_h#x) #
 first ((1 1 0N 2 4 4 8;"xx hief")@\:(),x[2]-0x08) 1:
 (h:4*1+x 3) _x}


\
\cd /Users/nick/q/ml/mnist
X:ldidx b:read1 `$"train-images-idx3-ubyte"
check:{[f]
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

f:`fastest`shortest`winghang
r:check each ([]func:f)!f

