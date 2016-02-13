RHO:.01 / a bunch of constants for line searches
SIG:.5  / RHO and SIG are the constants in the Wolfe-Powell conditions
INT:.1 / don't reevaluate within 0.1 of the limit of the current bracket
EXT:3f / extrapolate maximum 3 times the current bracket
MAX:20 / max 20 function evaluations per line search
RATIO:100 / maximum allowed slope ratio
REALMIN:2.2251e-308

polackribiere:{[f1;f2;s](((flip[f2 1]$f2 1)-flip[f1 1]$f2 1)%((flip[f1 1]$f1 1)$s))-f2 1}
quadfit:{[f2;f3;d3;z3]z3-(.5*d3*z3*z3)%(f2-f3)+d3*z3}
cubicfit:{[f2;f3;d3;z3]
 A:(6f*(f2-f3)%z3)+3f*d2+d3;
 B:(3f*f3-f2)-z3*d3+2f*d2;
 z2:(sqrt[(B*B)-A*d2*z3*z3]-B)%A; / numerical error possible - ok!
 z2}
cubicextrapolation:{[f2;f3;d3;z3]
 A:(6f*(f2-f3)%z3)+3f*d2+d3;
 B:(3f*f3-f2)-z3*d3+2f*d2;
 z2:(z3*z3*neg d2)%(B+sqrt[(B*B)-A*d2*z3*z3]); / numerical error possible - ok!
 z2}

minimize:{[f1;d3;d2;f2;z1;z3;X]
 z2:$[f2[0]>f1[0];quadfit;cubicfit][f2 0;f3 0;d3;z3];
 if[z2 in 0n -0w 0w;z2:.5*z3]; / if we had a numerical problem then bisect
 z2:(z3*1f-INT)|z2&INT*z3;     / don't accept too close to limits
 z1+:z2;
 X+:z2$s;
 f2:f X;
 d2:flip[f2 1]$s;
 z3-:z2;                    / z3 is now relative to the location of z2
 (d2;f2;z1;z3;X)}

extrapolate:{[f2;f3;d2;d3;z1;z3;X]
 z2:cubicextrapolation[f2 0;f3 0;d3;z3];
 z2:$[$[z2<0;1b;z2=0w];$[limit<=.5;z1*EXT-1f;.5*limit-z1];
  $[limit>-.5;limit<z2+z1;0b];.5*limit-z1; / extraplation beyond max? -> bisect
  $[limit<-.5;(z1*EXT)<z2+z1;0b];z1*EXT-1f; / extraplation beyond limit -> set to limit
  z2<z3*neg INT;z3*neg INT;
  $[limit>-.5;z2<(limit-z1)*1f-INT;0b];(limit-z1)*1f-INT; / too clost to limit?
  z2];
 f3:f2;d3:d2;z3:neg z2;       / set point 3 equal to point 2
 z1+:z2;X+:z2*s;                / update current estimates
 f2:f X;
 d2:flip[f2 1]$s;
 (f2;f3;d2;d3;z1;z3)}

/ TODO: rename length -> n
fmincg:{[length;f;X]            / length can default to 100
 i:0;                           / zero the run length counter
 ls_failed:0b;                  / no previous line search has failed
 fX:();
 f1:f X;                        / get function value and gradient
 s:neg f1 1;                    / search direction is steepest
 d1:neg flip[s]$s;              / this is the slope
 z1:(length,:1f)[1]%1f-d1;      / initial step is red/(|s|+1)
 length@:0;                     / length is first element
 i+:length<0;                   / count epochs?!

 while[i<abs length;            / while not finished
  i+:length>0;                  / count iterations?!
  X0:X;f0:f1;                   / make a copy of current values
  X+:z1$s;                      / begin line search
  f2:f X;
  i+:length<0;                  / count epochs?!
  d2:flip[f2 1]$s;
  f3:f1;d3:d1;z3:neg z1;      / initialize point 3 equal to point 1
  M:$[length>0;MAX;MAX&neg length-i];
  s11uccess:0b;limit:-1;          / initialize quantities
  BREAK:0b;
  while[not BREAK;
   while[$[M>0;$[f2[0]>f1[0]+z1*RHO*d1;1b;d2>neg SIG*d1;1b;0b];0b]
    limit:z1;                   / tighten the bracket
    X:minimize[f1;d3;d2;f2;z1;z3;X];d2:X 0;f2:X 1;z1:X 2;z3:X 3;X@:4;
    M-:1;i+:length<0;           / count epochs?!
    ];
   if[$[d2>d1*neg SIG;1b;f2[0]>f1[0]+d1*RHO*z1];BREAK:1b]; / this is a failure
   if[d2>SIG*d1;success:1b;BREAK:1b];            / success
   if[M=0;BREAK:1b];                             / failure
   if[not BREAK;
    X:extrapolate[f2;f3;d2;d3;z1;z3;X];f2:X 0;f3:X 1;d2:X 2;d3:X 3;z1:X 4;z3:X 5;X@:6;
    M-:1;i+:length<0;           / count epochs?!
    ];
   ];
  if[success;
   f1:f2;fX:flip flip[fX],'f1 0;
   show "Iteration ",string[i]," | Cost: ", string f1 0;
   s:polackribiere[f1;f2;s];      / Polack-Ribiere direction
   tmp:f1 1;f1[1]:f2 1;f2[1]:tmp; / swap derivatives
   d2:flip[f1 1]$s;
   if[d2>0;s:neg f1 1;d2:flip[neg s]$s]; / new slope must be negative, otherwise use steepest direction
   z1*:RATIO&d1%d2-REALMIN;              / slope ratio but max RATIO
   d1:d2;
   ];
  if[not success;
   X:X0;f1:f0;          / restore point from before failed line search
   if[$[ls_failed;1b;i>abs length];:(X;fX;i)]; / line search failed twice in a row or we ran out of time, so we give up
   tmp:f1 1;f1[1]:f2 1;f2[1]:tmp;        / swap derivatives
   s:neg f1 1;                           / try steepest
   d1:neg[flip s]$s;
   z1:1f%1f-d1;
   ];
  ls_failed:not success;        / line search failure
  ];
 (X;fX;i)}