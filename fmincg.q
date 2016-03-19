\d .fmincg

RHO:.01 / a bunch of constants for line searches
SIG:.5  / RHO and SIG are the constants in the Wolfe-Powell conditions
INT:.1 / don't reevaluate within 0.1 of the limit of the current bracket
EXT:3f / extrapolate maximum 3 times the current bracket
MAX:20 / max 20 function evaluations per line search
RATIO:100 / maximum allowed slope ratio
REALMIN:2.2251e-308

wolfepowell:{[d;f;z]$[d[2]>d[1]*neg SIG;1b;f[2;0]>f[1;0]+d[1]*RHO*z[1]]}
polackribiere:{[df1;df2;s](s*((df2$df2)-df1$df2)%df1$df1)-df2}
quadfit:{[f2;f3;d2;d3;z3]z3-(.5*d3*z3*z3)%(f2-f3)+d3*z3}
cubicfit:{[f2;f3;d2;d3;z3]
 A:(6f*(f2-f3)%z3)+3f*d2+d3;
 B:(3f*f3-f2)-z3*d3+2f*d2;
 z2:(sqrt[(B*B)-A*d2*z3*z3]-B)%A; / numerical error possible - ok!
 z2}
cubicextrapolation:{[f2;f3;d2;d3;z3]
 A:(6f*(f2-f3)%z3)+3f*d2+d3;
 B:(3f*f3-f2)-z3*d3+2f*d2;
 z2:(z3*z3*neg d2)%(B+sqrt[(B*B)-A*d2*z3*z3]); / numerical error possible - ok!
 z2}

minimize:{[v]
 v[`z;2]:$[v[`f;2;0]>v[`f;1;0];quadfit;cubicfit][v[`f;2;0];v[`f;3;0];v[`d;2];v[`d;3];v[`z;3]];
 if[v[`z;2] in 0n -0w 0w;v[`z;2]:.5*v[`z;3]]; / if we had a numerical problem then bisect
 v[`z;2]:(v[`z;3]*1f-INT)|v[`z;2]&INT*v[`z;3]; / don't accept too close to limits
 v[`z;1]+:v[`z;2];
 v[`X]+:v[`z;2]*v[`s];
 v[`f;2]:v[`F] v[`X];
 v[`d;2]:v[`f;2;1]$v[`s];
 v[`z;3]-:v[`z;2];                / z3 is now relative to the location of z2
 v}

extrapolate:{[v]
 v[`z;2]:cubicextrapolation[v[`f;2;0];v[`f;3;0];v[`d;2];v[`d;3];v[`z;3]];
 v[`z;2]:$[$[v[`z;2]<0;1b;v[`z;2]=0w];$[v[`limit]<=.5;v[`z;1]*EXT-1f;.5*v[`limit]-v[`z;1]];
  $[v[`limit]>-.5;v[`limit]<v[`z;2]+v[`z;1];0b];.5*v[`limit]-v[`z;1]; / extraplation beyond max? -> bisect
  $[v[`limit]<-.5;(v[`z;1]*EXT)<v[`z;2]+v[`z;1];0b];v[`z;1]*EXT-1f; / extraplation beyond limit -> set to limit
  v[`z;2]<v[`z;3]*neg INT;v[`z;3]*neg INT;
  $[v[`limit]>-.5;v[`z;2]<(v[`limit]-v[`z;1])*1f-INT;0b];(v[`limit]-v[`z;1])*1f-INT; / too clost to limit?
  v[`z;2]];
 v[`f;3]:v[`f;2];v[`d;3]:v[`d;2];v[`z;3]:neg v[`z;2]; / set point 3 equal to point 2
 v[`z;1]+:v[`z;2];v[`X]+:v[`z;2]*v[`s];              / update current estimates
 v[`f;2]:v[`F] v[`X];
 v[`d;2]:v[`f;2;1]$v[`s];
 v}

loop:{[n;v]
 v[`i]+:n>0;                        / count iterations?!
 v[`X]+:v[`z;1]*v[`s];                     / begin line search
 v[`f;2]:v[`F] v[`X];
 v[`i]+:n<0;                        / count epochs?!
 v[`d;2]:v[`f;2;1]$v[`s];
 v[`f;3]:v[`f;1];v[`d;3]:v[`d;1];v[`z;3]:neg v[`z;1]; / initialize point 3 equal to point 1
 v[`M]:$[n>0;MAX;MAX&neg n-v[`i]];
 v[`success]:0b;v[`limit]:-1;           / initialize quantities
 BREAK:0b;
 while[not BREAK;
  while[$[v[`M]>0;wolfepowell[v[`d];v[`f];v[`z]];0b];
   v[`limit]:v[`z;1];                  / tighten the bracket
   v:minimize[v];
   v[`M]-:1;v[`i]+:n<0;                 / count epochs?!
   ];
  if[wolfepowell[v[`d];v[`f];v[`z]];BREAK:1b];        / this is a failure
  if[v[`d;2]>SIG*v[`d;1];v[`success]:1b;BREAK:1b]; / success
  if[v[`M]=0;BREAK:1b];                      / failure
  if[not BREAK;
   v:extrapolate[v];
   v[`M]-:1;v[`i]+:n<0;                / count epochs?!
   ];
  ];
 v}

onsuccess:{[v]
 v[`f;1;0]:v[`f;2;0];
 -1"Iteration ",string[v[`i]]," | cost: ", string v[`f;1;0];
 v:@[v;`s;polackribiere[v[`f;1;1];v[`f;2;1]]]; / Polack-Ribiere direction
/ break;
 v[`f;2 1;1]:v[`f;1 2;1];                / swap derivatives
 v[`d;2]:v[`f;1;1]$v[`s];
 if[v[`d;2]>0;v[`s]:neg v[`f;1;1];v[`d;2]:v[`s]$neg v[`s]]; / new slope must be negative, otherwise use steepest direction
 v[`z;1]*:RATIO&v[`d;1]%v[`d;2]-REALMIN;        / slope ratio but max RATIO
 v[`d;1]:v[`d;2];
 v}

fmincg:{[n;F;X]                 / n can default to 100
 v:`F`X!(F;X);
 v[`i]:0;                           / zero the run length counter
 ls_failed:0b;                  / no previous line search has failed
 fX:();
 v[`f]:4#enlist 2#0n;               / make room for f0, f1, f2 and f3
 v[`z]:4#0n;                        / make room for z0, z1, z2 and z3
 v[`d]:4#0n;                        / make room for d0, d1, d2 and d3
 v[`f;1]:v[`F] v[`X];                      / get function value and gradient
 v[`s]:neg v[`f;1;1];                  / search direction is steepest
 v[`d;1]:v[`s]$neg v[`s];                  / this is the slope
 v[`z;1]:(n:n,1)[1]%1f-v[`d;1];       / initial step is red/(|s|+1)
 n@:0;                          / n is first element
 v[`i]+:n<0;                        / count epochs?!

 while[v[`i]<abs n;                 / while not finished
  X0:v[`X];v[`f;0]:v[`f;1];               / make a copy of current values
  v:loop[n;v];
  if[v[`success];fX,:v[`f;2;0];v:onsuccess[v]];
  if[not v[`success];
   v[`X]:X0;v[`f;1]:v[`f;0];     / restore point from before failed line search
   if[$[ls_failed;1b;v[`i]>abs n];:(v[`X];fX;v[`i])]; / line search failed twice in a row or we ran out of time, so we give up
   v[`f;2 1;1]:v[`f;1 2;1];                           / swap derivatives
   v[`z;1]:1f%1f-v[`d;1]:v[`s]$neg v[`s]:neg v[`f;1;1];         / try steepest
   ];
  ls_failed:not v[`success];        / line search failure
  ];
 (v[`X];fX;v[`i])}