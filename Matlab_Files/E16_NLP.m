% Non-Linear Programming (Quadratically Constrainted Problems)
% Toy Problem 1

function E16_NLP
%fun = @chap3_fun1;
fun = @(x) sum(x(1:3));

% Non-linear constraints
nonlcon = @chap3_nonlcon1;

% Ax <= b
A = [];
b = [];

% Aeqx <= beq
Aeq = [];
beq = [];

% bounds on variables
lb = [100; 1000; 1000; 10; 10; 10; 10; 10];
ub = 1000*ones(8, 1); 
ub(1:3, 1) = 10*ub(1:3, 1);  

% One of the initial values of the variables apart from 200 other values
x0 = ub;

options = optimoptions('fmincon',...
     'Algorithm','interior-point','Display','off', 'GradObj', 'off');
%options = optimoptions('ga', 'Display', 'off', 'PopulationSize', 500); 

%problem = createOptimProblem('fmincon', 'x0', x0, 'objective', @(x) sum(x(1:3)), 'lb', lb, 'ub', ub, 'nonlcon', nonlcon);
problem = createOptimProblem('fmincon', 'x0', x0, 'objective', fun, ...
                                  'lb', lb, 'ub', ub, 'nonlcon', nonlcon);
ms = MultiStart;
[out.x, out.fval, out.exitflag, out.output, out.solutions] = run(ms, problem, 200);

%[out.x, out.fval, out.exitflag, out.OutputStruct, out.Population] = ga(fun, 8, [], [], [], [], lb, ub, nonlcon  );

out

end

% Non-Linear Constraints
function [c, ceq] = chap3_nonlcon1(x)

c = [ ( -1 + 0.0025*( x(4) + x(6) ) );...
      ( -1 + 0.0025*( -x(4) + x(5) + x(7) ) );...
      ( -1 + 0.01*( -x(5) + x(8) ) );...
      ( 100*x(1) - x(1)*x(6) + 8333.33252*x(4) - 83333.333 );...
      ( x(2)*x(4) - x(2)*x(7) - 1250*x(4) + 1250*x(5) );...
      ( x(3)*( x(5) - x(8) ) -2500*x(5) + 1250000 ) ];
ceq = [];

end