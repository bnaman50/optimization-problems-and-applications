function E26_PlanProb

% Mixed integer Non-linear Programming
% Planning Problem 

% Objective Function
fun = @Plan_fun;

% % Variable definition as per the original problem
%y1 = x(1); y2 = x(2); y3 = x(3);
%b1 = x(4); b2 = x(5); b3 = x(6);
%a = x(7); c = x(8);
%b = x(9); 
%a2 = x(10); a3 = x(11);

% non-linear constraints
nlcon = @Plan_nonlcon;
nlrhs = [ zeros(2, 1) ];
nle = [ zeros(2, 1 ) ];      % -1 for <=, 0 for == and 1 for >=

nvars = 11;

% Aeq*x <= beq
Aeq = [ 0 0 0 0 0 0 0 1 -0.9 0 0;
        0 0 0 1 1 1 0 0 -1 0 0;
        0 0 0 0 0 0 1 0 0 -1 -1 ];
beq = [ 0; 0; 0 ];

% A*x <= b
A = [ -5 0 0 0 0 0 0 0 1 0 0;
      0 -5 0 0 0 0 0 0 0 1 0;
      0 0 -5 0 0 0 0 0 0 0 1 ];
b = [ 0; 0; 0 ];

% bounds on variables
lb = zeros(11, 1);
ub = [ 1; 1; 1; 5; 5; 5; 10; 1; 5; 5; 5 ]; % Upper limits can be derived from inequalities 
        
% integer constraints (variables listed in intcon takes integral values)        
xtype = [ repmat('B', 1, 3) ,repmat('C', 1, 8) ];

% initial value
y0 = ub;

%Specify to use the COIN-OR LP solver CLP
opts = optiset('solver','SCIP', 'maxiter', 1.5e9, 'maxfeval', 1e50, ...
               'maxnodes', 1e9, 'maxtime', 1e20, 'tolafun', 1e-4, ...
               'tolint', 1e-4, 'warnings', 'critical', 'display', 'iter', 'derivCheck', 'off');

% Create OPTI Object
Opt = opti('fun', fun, 'nlmix', nlcon, nlrhs, nle, 'ineq', A, b, 'eq', Aeq, beq, 'bounds', lb, ub,...
           'xtype', xtype, 'ndec', 11, 'options', opts)


       
%%       
[x, fval, exitflag, info] = solve(Opt, y0)

end

% objective function
function [fval] = Plan_fun(x)

fval = 3.5*x(1) + x(2) + 1.5*x(3) + 7.0*x(4) + x(5) + 1.2*x(6) + 1.8*x(7) - 11*x(8);
end

% non-linear constraints
function c = Plan_nonlcon(x)

% variable definition 
y1 = x(1); y2 = x(2); y3 = x(3);
b1 = x(4); b2 = x(5); b3 = x(6);
a = x(7); c = x(8);
b = x(9); 
a2 = x(10); a3 = x(11);

c = [ ( b2 - log(1 + a2) );...
      ( b3 - 1.2*log(1 + a3) );...
 
      ];

end

