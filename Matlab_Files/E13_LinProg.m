% Linear Programming
% Toy example 1 

% Ax <= b
A = [1, 1; 1, 1/4; 1, -1; -1/4, -1; -1, -1; -1, 1];
b = [2 1 2 1 -1 2];

% Aeqx = beq
Aeq = [1 1/4];
beq = 1/2;

% bounds on variables
lb = [-1,-0.5];
ub = [1.5,1.25];

% objective function ( f.x )
f = [-1 -1/3];

options = optimoptions('linprog','Algorithm','interior-point');

[x, fval, exitflag, output] = linprog(f,A,b,Aeq,beq,lb,ub, options);