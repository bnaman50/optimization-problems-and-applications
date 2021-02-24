function E19_INLP1
% Integer Non-Linear Programming (Quadratic Integer Programming)
% Toy problem

%ga takes x as row vector
c = [6, 8, 4, -2];
Q = [-1, 2, 0, 0;
     2, -1, 2, 0;
     0, 2, -1, 2;
     0, 0, 2, -1];

% Objective Function 
fun = @(x) ( c*x' + x*Q*x' );

% Non-linear Constraints
nonlcon = @INLP_nonlcon1;

nvars = 4;

% Ax <= b
A = [];
b = [];

% Aeqx <= beq
Aeq = [];
beq = [];

% bounds on variables
lb = [-1; -1; -1; -1];
ub = [1; 1; 1; 1];

% integer constraints (variables listed in intcon takes integral values)
IntCon = [1, 2, 3, 4];

% Initial value of variables
x0 = lb;

options = optimoptions(@ga,'MutationFcn',@mutationadaptfeasible);
[out.x, out.fval, out.exitflag] = ga(fun, nvars, [], [], [], [], ...
                                     lb, ub, nonlcon, IntCon, options );

out

end

% Non-linear constraints
function [c, ceq] = INLP_nonlcon1(x)

c = [ ( x(1)*x(2) + x(3)*x(4) -1 );...
      ( -x(1)*x(2) - x(3)*x(4) -1 );...
      ( sum(x) - 2 );...
      ( -sum(x) - 3 );...
      
      % this is to make sure that 0 is not a feasible point
      ( -norm(x, 1) + 0.1 )];  
  
ceq = [];

end