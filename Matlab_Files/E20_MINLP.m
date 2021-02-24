function E20_MINLP
% Mixed Integer Non-Linear Programming
% Toy Problem 1

% Objective Function 
fun = @(x) ( 3*x(1) - 5*x(2) );

% non-linear constraints
nonlcon = @MINLP_nonlcon;

nvars = 2;

% Ax <= b
A = [];
b = [];

% Aeqx <= beq
Aeq = [];
beq = [];

% bounds on variables
lb = [1; 1];
ub = [6; 10];

% integer constraints (variables listed in intcon takes integral values)
IntCon = [1];

% initial value of variables
x0 = lb;

options = optimoptions(@ga,'MutationFcn',@mutationadaptfeasible);
[out.x, out.fval, out.exitflag] = ga(fun, nvars, [], [], [], [], ...
                                     lb, ub, nonlcon, IntCon, options );
                                 
end

% non-linear constraints
function [c, ceq] = MINLP_nonlcon(x)

c = [ ( 2*x(1)^2 - 2*x(1)^0.5 - 2*(x(2)^0.5)*x(1)^2 + 11*x(1) + 8*x(2) - 39 );...
      ( -x(1) + x(2) - 3 );...
      ( 2*x(1) +3*x(2) - 24 )];
ceq = [];

end