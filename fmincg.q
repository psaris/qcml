RHO:.01; / a bunch of constants for line searches
SIG:.5; / RHO and SIG are the constants in the Wolfe-Powell conditions
INT:.1; / don't reevaluate within 0.1 of the limit of the current bracket
EXT:3f; / extrapolate maximum 3 times the current bracket
MAX:20; / max 20 function evaluations per line search
RATIO:100; / maximum allowed slope ratio
LENGTH:100;

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
 
/ TODO: configure red variable
fmincg:{[f;X;options]
 i:0;                           / zero the run length counter
 ls_failed:0b;                  / no previous line search has failed
 fX:();
 f1:first df1:f X;df1:last df1; / get function value and gradient
 i+:LENGTH<0;                   / count epochs?!
 s:neg df1;                     / search direction is steepest
 d1:neg flip[s]$s;              / this is the slope
 z1:red%1f-d1;                  / initial step is red/(|s|+1)

 while[i<abs LENGTH;            / while not finished
  i+:LENGTH>0;                  / count iterations?!
  X0:X;f0:f1;df0:df1;           / make a copy of current values
  X+:z1$s;                      / begin line search
  f2:first df2:f X;df2:last df2;
  i+:LENGTH<0;                  / count epochs?!
  d2:flip[df2]$s;
  f3:f1;d3:d1;z3:neg z1;        / initialize point 3 equal to point 1
  M:$[LENGTH>0;MAX;MAX&neg LENGTH-i];
  success:0;limit:-1;           / initialize quanteties
  BREAK:0b;
  while[not BREAK;
   while[(M>0) & (f2 > f1+z1*RHO*d1) | d2 > neg SIG*d1;
    limit:z1;                    / tighten the bracket
    z2:$[f2>f1;quadfit;cubicfit][f2;f3;d3;z3];
    if[z2 in 0n -0w 0w;z2:.5*z2];  / if we had a numerical problem then bisect
    z2:(z3*1f-INT)|z2&INT*z3;      / don't accept too close to limits
    z1+:z2;
    X+:z2$s;
    f2:first df2:f X;df2:last df2;
    M-:1;i+:LENGTH<0;            / count epochs?!
    d2:flip[df2]$s;
    z3-:z2;                 / z3 is now relative to the location of z2
    ];
   if[(d2>d1*neg SIG)|f2>f1+d1*RHO*z1;BREAK:1b]; / this is a failure
   if[d2>SIG*d1;success:1b;BREAK:1b];            / success
   if[M=0;BREAK:1b];                             / failure
   if[not BREAK;
    z2:cubicextrapolation[f2;f3;d3;z3];
    z2:$[(z2<0)|z2=0w;$[limit<=.5;z1*EXT-1f;.5*limit-z1];
     (limit>-.5)&limit<z2+z1;.5*limit-z1; / extraplation beyond max? -> bisect
     (limit<-.5)&(z1*EXT)<z2+z1;z1*EXT-1f; / extraplation beyond limit -> set to limit
     z2<z3*neg INT;z3*neg INT;
     (limit>-.5)&(z2<(limit-z1)*1f-INT);(limit-z1)*1f-INT; / too clost to limit?
     z2];
    f3:f2;d3:d2;z3:neg z2;      / set point 3 equal to point 2
    z1+:z2;x+:z2*s;             / update current estimates
    f2:first df2:f X;df2:last df2;
    M-:1;i+:LENGTH<0;           / count epochs?!
    d2:flip[df2]$s;
    ];
   ];
  if[success;
   f1:f2;fX:flip flip[fX],'f1;
   show "Iteration ",string[i]," | Cost: ", string f1;
   s:(((flip[df2]$df2)-flip[df1]$df2)%((flip[df1]$df1)$s))-df2; / Polack-Ribiere diretion
   tmp:df1;df1:df2;df2:tmp;          / swap derivatives
   d2:flip[df1]$s;
   if[d2>0;s:neg df1;d2:flip[neg s]$s]; / new slope must be negative, otherwise use steepest direction
   z1*:RATIO&d1%d2-2.2251e-308;         / slope ratio but max RATIO
   d1:d2;
   ls_failed:0b;                / this line search did not fail
   ];
  if[not success;
   X:X0;f1:f0;df1:df0;          / restore point from before failed line search
   if[ls_failed|i>abs LENGTH;:(X;fX;i)]; / line search failed twice in a row or we ran out of time, so we give up
   tmp:df1;df1:df2;df2:tmp;              / swap derivatives
   s:neg df1;                            / try steepest
   d1:neg[flip s]$s;
   z1:1f%1f-d1;
   ls_failed:1b;                / this line search failed
   ];
  ];
 (X;fX;i)}