function E25_TrimLoss

% Mixed integer Non-linear Programming
% Trim Loss Minimization Problem 

% Objective Function
fun = @trim_fun;

%Data
N = 4; P = 4; Bmax = 1850; del = 100;
n = [ 15; 28; 21; 30 ];
b = [ 290; 315; 350; 455 ];
M = [ 30; 30; 30; 30 ];

% non-linear constraints
nlcon = @trim_nonlcon;
nlrhs = [ n(1); n(1); n(3); n(4) ];
nle = [ 1; 1; 1; 1 ];      % -1 for <=, 0 for == and 1 for >=

nvars = 24;

% Aeq*x = beq
Aeq = [];
beq = [];

% A*x <= b
A = [ %Sum of breadths of each prodcuts be greater than (Bmax - del) 
      (Bmax-del) 0 0 0 0 0 0 0 -b(1) 0 0 0 -b(2) 0 0 0 -b(3) 0 0 0 -b(4) 0 0 0;
      0 (Bmax-del) 0 0 0 0 0 0 0 -b(1) 0 0 0 -b(2) 0 0 0 -b(3) 0 0 0 -b(4) 0 0;
      0 0 (Bmax-del) 0 0 0 0 0 0 0 -b(1) 0 0 0 -b(2) 0 0 0 -b(3) 0 0 0 -b(4) 0;
      0 0 0 (Bmax-del) 0 0 0 0 0 0 0 -b(1) 0 0 0 -b(2) 0 0 0 -b(3) 0 0 0 -b(4);
        
      %Sum of breadths of each prodcuts be less than Bmax 
      -Bmax 0 0 0 0 0 0 0 b(1) 0 0 0 b(2) 0 0 0 b(3) 0 0 0 b(4) 0 0 0;
      0 -Bmax 0 0 0 0 0 0 0 b(1) 0 0 0 b(2) 0 0 0 b(3) 0 0 0 b(4) 0 0;
      0 0 -Bmax 0 0 0 0 0 0 0 b(1) 0 0 0 b(2) 0 0 0 b(3) 0 0 0 b(4) 0;
      0 0 0 -Bmax 0 0 0 0 0 0 0 b(1) 0 0 0 b(2) 0 0 0 b(3) 0 0 0 b(4);
        
      1 0 0 0 0 0 0 0 -1 0 0 0 -1 0 0 0 -1 0 0 0 -1 0 0 0;
      0 1 0 0 0 0 0 0 0 -1 0 0 0 -1 0 0 0 -1 0 0 0 -1 0 0;
      0 0 1 0 0 0 0 0 0 0 -1 0 0 0 -1 0 0 0 -1 0 0 0 -1 0;
      0 0 0 1 0 0 0 0 0 0 0 -1 0 0 0 -1 0 0 0 -1 0 0 0 -1;
        
      -5 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0;
      0 -5 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0;
      0 0 -5 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0;
      0 0 0 -5 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1;
        
      1 0 0 0 -1 0 0 0 zeros(1, 16);
      0 1 0 0 0 -1 0 0 zeros(1, 16);
      0 0 1 0 0 0 -1 0 zeros(1, 16);
      0 0 0 1 0 0 0 -1 zeros(1, 16);
      
      -30 0 0 0 1 0 0 0 zeros(1, 16);
      0 -30 0 0 0 1 0 0 zeros(1, 16);
      0 0 -30 0 0 0 1 0 zeros(1, 16);
      0 0 0 -30 0 0 0 1 zeros(1, 16);
      
      0 0 0 0 -1 -1 -1 -1 zeros(1, 16);
      
      -1 1 0 0 zeros(1, 20);
      0 -1 1 0 zeros(1, 20);
      0 0 -1 1 zeros(1, 20);
      
      0 0 0 0 -1 1 0 0 zeros(1, 16);
      0 0 0 0 0 -1 1 0 zeros(1, 16);
      0 0 0 0 0 0 -1 1 zeros(1, 16);
      ];
b = [ zeros(24, 1); -19; zeros(6, 1) ];

% bounds on variables
lb = zeros(24, 1);
ub = [ ones(4, 1); 30*ones(4, 1); 5*ones(16, 1) ];  
        
% integer constraints (variables listed in intcon takes integral values)        
xtype = [ repmat('B', 1, 4) ,repmat('I', 1, 20) ];

% initial value
y0 = ub;

%Specify to use the COIN-OR LP solver CLP
opts = optiset('solver','SCIP', 'maxiter', 1.5e9, 'maxfeval', 1e50, ...
               'maxnodes', 1e9, 'maxtime', 1e20, 'tolafun', 1e-4, ...
               'tolint', 1e-4, 'warnings', 'critical', 'display', 'iter', 'derivCheck', 'off');

% Create OPTI Object
Opt = opti('fun', fun, 'nlmix', nlcon, nlrhs, nle, 'ineq', A, b, 'eq', Aeq, beq, 'bounds', lb, ub,...
           'xtype', xtype, 'ndec', 24, 'options', opts)
  
[x, fval, exitflag, info] = solve(Opt, y0)

end

% objective function
function [fval] = trim_fun(x)
% x is a coloumn vector 
a = 1
fval = sum( x(5:8) ) + sum( 0.1*(1:4).*x(1:4) );
end

% non-linear constraints
function c = trim_nonlcon(x)
N = 4; P = 4; Bmax = 1850; del = 100;
n = [ 15; 28; 21; 30 ];
b = [ 290; 315; 350; 455 ];
M = [ 30; 30; 30; 30 ];

% Variable definition as per the original problem
y = x(1:4);
%y1 = x(1); y2 = x(2); y3 = x(3); y4 = x(4);

m = x(5:8);
%m1 = x(5); m2 = x(6); m3 = x(7); m4 = x(8);

r = reshape( x(9:end), [4, 4] )';
%r11 = x(9); r12 = x(10); r13 = x(11); r14 = x(12);
%r21 = x(13); r22 = x(14); r23 = x(15); r24 = x(16);
%r31 = x(17); r32 = x(18); r33 = x(19); r34 = x(20);
%r41 = x(21); r42 = x(22); r43 = x(23); r44 = x(24);

%
c = [ % Number of products of each type should meet the requirements
      ( r(1, :)*m );...
      ( r(2, :)*m );...
      ( r(3, :)*m );...
      ( r(4, :)*m );... 
      ];

end

