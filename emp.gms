$title simple example of ENLP

Positive Variables x, y;
Variables f, z;
Equations g, h, defobj;

g..      x + y     =l= 1;
h..      x + y - z =e= 2;
defobj.. f         =e= -3*x + y;

model comp / defobj, g, h /;

 file info / '%emp.info%' /;
 putclose info / 'modeltype mcp';

comp.optfile=1;

solve comp using emp minimizing f;