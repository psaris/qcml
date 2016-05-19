\d .mnist

ldidx:{
 d:first (1#4;1#"i") 1: 4_(h:4*1+x 3)#x;
 x:first ((1 1 0N 2 4 4 8;"xx hief")@\:(),x[2]-0x08) 1: h _x;
 x:((prd[d])#x){y cut x}/reverse 1_d;
 x}
