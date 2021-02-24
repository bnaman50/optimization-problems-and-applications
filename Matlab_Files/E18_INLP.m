function E18_INLP
% Integer Non-linear Programming
% Toy Problem 

% Objective function
fun = @(x) (7*x(1) + 10*x(2));

% Non-linear Constraints
nonlcon = @INLP_nonlcon;

nvars = 2;

% Ax <= b
A = [];
b = [];

% Aeqx <= beq
Aeq = [];
beq = [];

% bounds on variables
lb = [1; 1];
ub = [5; 5];

% integer constraints (variables listed in intcon takes integral values)
IntCon = [1, 2];

% Initital value of variables
x0 = lb;

options = optimoptions(@ga,'MutationFcn',@mutationadaptfeasible);
[out.x, out.fval, out.exitflag, out.OutputStruct] = ga(fun, nvars, ...
                        [], [], [], [], lb, ub, nonlcon, IntCon, options );

out

end

% Non-Linear Constraints
function [c, ceq] = INLP_nonlcon(x)

c = [ ( (x(1)^1.2)*(x(2)^1.7) -7*x(1) -9*x(2) -24 );...
      ( -x(1) - 2*x(2) -5 );...
      ( -3*x(1) + x(2) - 1);...
      ( 4*x(1) - 3*x(2) - 11 ) ];
ceq = [];

end