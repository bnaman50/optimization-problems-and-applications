function E24_PumpConfig
% Mixed integer Non-linear Programming
% Pump Network Synthesis Problem

Vtol = 350; wmax = 2950; Pmax = [80; 25; 35]; delP_tol = 400; 

% Objective Function
fun = @Pump_fun;

% non-linear constraints
nlcon = @Pump_nonlcon;
nlrhs = [zeros(12, 1)];
nle = [ zeros(12, 1 ) ];      %  -1 for <=, 0 for == and 1 for >=

nvars = 24;

% Aeq*x <= beq
Aeq = sparse( [ones(1, 3) zeros(1, 21)] ); % x1 + x2 +x3 = 1
beq = [1];

% A*x <= b
A = sparse( ... 
    [ zeros(1, 6), 1, 0, 0, zeros(1, 12), -wmax, 0, 0;...        % w1 - wmax*z1 <=0
      zeros(1, 6), 0, 1, 0, zeros(1, 12), 0, -wmax, 0;...        % w2 - wmax*z2 <=0
      zeros(1, 6), 0, 0, 1, zeros(1, 12), 0, 0, -wmax;...        % w3 - wmax*z3 <=0
      
      zeros(1, 9), 1, 0, 0, zeros(1, 9), -Pmax(1), 0, 0;...      % P1 - Pmax1*z1 <=0
      zeros(1, 9), 0, 1, 0, zeros(1, 9), 0, -Pmax(2), 0;...      % P2 - Pmax2*z2 <=0
      zeros(1, 9), 0, 0, 1, zeros(1, 9), 0, 0, -Pmax(3);...      % P3 - Pmax3*z3 <=0
      
      zeros(1, 12), 1, 0, 0, zeros(1, 6), -delP_tol, 0, 0;...    % delP1 - delP_tol*z1 <=0
      zeros(1, 12), 0, 1, 0, zeros(1, 6), 0, -delP_tol, 0;...    % delP2 - delP_tol*z2 <=0
      zeros(1, 12), 0, 0, 1, zeros(1, 6), 0, 0, -delP_tol;...    % delP3 - delP_tol*z3 <=0
      
      zeros(1, 3), 1, 0, 0, zeros(1, 15), -Vtol, 0, 0;...        % vdot1 - Vtol*z1 <=0
      zeros(1, 3), 0, 1, 0, zeros(1, 15), 0, -Vtol, 0;...        % vdot2 - Vtol*z2 <=0
      zeros(1, 3), 0, 0, 1, zeros(1, 15), 0, 0, -Vtol;...        % vdot3 - Vtol*z3 <=0
      
      1 zeros(1, 20) -1 0 0; ...                                 % x1 - z1 <= 0
      0 1 zeros(1, 20) -1 0; ...                                 % x2 - z2 <= 0
      0 0 1 zeros(1, 20) -1; ...                                 % x3 - z3 <= 0
      
      zeros(1, 18) 1 0 0 -3 0 0; ...                             % Ns1 - 3z1 <= 0
      zeros(1, 18) 0 1 0 0 -3 0; ...                             % Ns2 - 3z2 <= 0
      zeros(1, 18) 0 0 1 0 0 -3; ...                             % Ns3 - 3z3 <= 0
      
      zeros(1, 15) 1 0 0 0 0 0 -3 0 0; ...                       % Np1 - 3z1 <= 0
      zeros(1, 15) 0 1 0 0 0 0 0 -3 0; ...                       % Np2 - 3z2 <= 0
      zeros(1, 15) 0 0 1 0 0 0 0 0 -3] );                        % Np3 - 3z3 <= 0
b = [zeros(21, 1)];

% bounds on variables
lb = zeros(24, 1);
ub = ones(24, 1); 
ub(4:6) = Vtol*ub(4:6);       ub(7:9) = wmax*ub(7:9); 
ub(10:12) = Pmax.*ub(10:12);  ub(13:15) = delP_tol*ub(13:15); 
ub(16:18) = 3*ub(16:18);      ub(19:21) = 3*ub(19:21);
        
% integer constraints (variables listed in intcon takes integral values)        
xtype = [ repmat('C', 1, 15) ,repmat('I', 1, 6), repmat('B', 1, 3) ];

% initial value
y0 = lb;

%Specify to use the COIN-OR LP solver CLP
%opts = optiset('solver','SCIP');
opts = optiset('solver','SCIP', 'maxiter', 1.5e9, 'maxfeval', 1e50, ...
               'maxnodes', 1e9, 'maxtime', 1e20, 'tolafun', 1e-4, ...
               'tolint', 1e-4, 'warnings', 'critical', 'display', 'iter', 'derivCheck', 'off');

% Create OPTI Object
Opt = opti('fun', fun, 'nlmix', nlcon, nlrhs, nle, 'eq', Aeq, beq, 'ineq', A, b,'bounds', lb, ub,...
           'xtype', xtype, 'ndec', 24, 'options', opts)
            
%%       
[x, fval, exitflag, info] = solve(Opt, y0)

end

% objective function
function [fval] = Pump_fun(y)

C = [6329.03, 2489.31, 3270.27];
Cprime = [1800, 1800, 1800];

fval = ( ( C(1) + Cprime(1)*y(10) )*y(16)*y(19)*y(22) ) + ...
       ( ( C(2) + Cprime(2)*y(11) )*y(17)*y(20)*y(23) ) + ...
       ( ( C(3) + Cprime(3)*y(12) )*y(18)*y(21)*y(24) );
end

% non-linear constraints
function c = Pump_nonlcon(y)

% variable definition 
x = y(1:3); vdot = y(4:6); w = y(7:9); P = y(10:12); delP = y(13:15); Np = y(16:18); Ns = y(19:21); z = y(22:24);
Vtol = 350; wmax = 2950; Pmax = [80, 25, 35];   delP_tol = 400; 

wprime = w/wmax;

c = [ ( P(1) - 19.9*wprime(1)^3 - 0.1610*(wprime(1)^2)*vdot(1) + 0.000561*wprime(1)*vdot(1)^2 );...
 
      ( P(2) - 1.21*wprime(2)^3 - 0.0644*(wprime(2)^2)*vdot(2) + 0.000564*wprime(2)*vdot(2)^2 );...
 
      ( P(3) - 6.52*wprime(3)^3 - 0.1020*(wprime(3)^2)*vdot(3) + 0.000232*wprime(3)*vdot(3)^2 );...
 
      ( delP(1) - 629*wprime(1)^2 - 0.696*wprime(1)*vdot(1) + 0.0116*vdot(1)^2 );...
 
      ( delP(2) - 215*wprime(2)^2 - 2.950*wprime(2)*vdot(2) + 0.115*vdot(2)^2 );...
 
      ( delP(3) - 361*wprime(3)^2 - 0.530*wprime(3)*vdot(3) + 0.00946*vdot(3)^2 );...
 
      ( vdot(1)*Np(1) - x(1)*Vtol );...
 
      ( vdot(2)*Np(2) - x(2)*Vtol );...
 
      ( vdot(3)*Np(3) - x(3)*Vtol );... 
 
      ( delP_tol*z(1) - delP(1)*Ns(1) );...
 
      ( delP_tol*z(2) - delP(2)*Ns(2) );...
 
      ( delP_tol*z(3) - delP(3)*Ns(3) );...
      ];

end