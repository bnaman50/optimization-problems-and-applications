function E14_QP1
% Quadratic Programming
% Toy problem 1

fun = @prac_fun;

% Ax <= b
A = [20, 12, 11, 7, 4];
b = 40;

% Aeqx = beq
Aeq = [];
beq = [];

% bounds on the variables
lb = zeros(5, 1);
ub = ones(5, 1);
  
options = optimoptions('ga', 'Display','off'); %, 'GradObj', 'on' , 'PlotFcn',{@gaplotbestf,@gaplotstopping}
%options.PopulationSize = 1000; , 'OutputFcns', @my_view
%options = optimoptions(options,'MaxGenerations',300,'MaxStallGenerations', 100);

disp('Working')
%[x, fval, ~, output] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, [], options);
[x, fval, exitflag, output, population ] = ga(fun, 5, A, b, Aeq, beq, lb, ub, [], options);

format short
fval
x
end

function [fval] = prac_fun(x)
    H = 100*speye(5);
    f = [42, 44, 45, 47, 47.5];
    fval = f*x' - 0.5*x*H*x';
    %grad = f - H*x;
end
