% Quadratic Programming
% Toy problem 2
function E15_QP2
fun = @fun2;

% Ax <= b
A = [6, 3, 3, 2, 1, 0; 10, 0, 10, 0, 0, 1];
b = [6.5; 20];

% Aeqx <= beq
Aeq = [];
beq = [];

% bounds on variables
lb = zeros(6, 1);
ub = ones(6, 1); 
ub(6, 1) = Inf;  

options = optimoptions('ga', 'Display', 'off', 'PopulationSize', 50);

[x, fval, exitflag, output, population ] = ga(fun, 6, A, b, Aeq, beq, lb, ub, [], options);

format short
x
fval
exitflag

end

% objective function
function [fval] = fun2(x)
c = [-10.5, -7.5, -3.5, -2.5, -1.5]';
d = -10;
Q = 100*speye(5);
fval = x(1:5)*c - 0.5*x(1:5)*Q*x(1:5)' + d*x(6);
end