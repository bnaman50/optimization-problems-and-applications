% Integer Linear Programming
% Toy Problem 1

% Ax <= b
A = [ 5, 7, 4, 3;
      1, 1, 1, 1;
      0, 1, 0, -1;
      1, 0, 1, 0 ];
b = [ 14; 2; 0; 1 ];

% Aeqx <= beq
Aeq = [];
beq = [];

% bounds on variables
lb = [0 0 0 0];
ub = [1 1 1 1];

% integer constraints (variables listed in intcon takes integral values)
intcon = [1 2 3 4]; 

% Objective Function (f'x)
f = [-8; -11; -6; -4]; % Because we have to maximize the objective function 

options = optimoptions('intlinprog','Display','off');

[x, fval, exitflag, output] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, options);
