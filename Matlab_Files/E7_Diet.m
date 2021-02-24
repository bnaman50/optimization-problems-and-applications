% ILP example
% Buying food with dietary and economic considerations
% Reference http://home.ubalt.edu/ntsbarsh/opre640A/partVIII.htm
 
A = -[2 1; 4 4; 1 4]; B = -[9;20;6]; % Ax<=B

Aeq = [0,0;0,0;0,0]; Beq = [0;0;0];  % Aeq=Beq

lb = [0,0]; ub = [ , ]; % lower bound and upper bound

% total cost= no of potatoes*30 + no of apples*45
tc = [30,45]; % tc(1) = cost of a potato
              % tc(2) = cost of a apple
              
x = [ ; ];  % x = [potatoes(p); Apples(a)]

intcon = [1,2]; % no of potatoes(x(1)) and apples(x(2)) are integer

[x,tc,exitflag] = intlinprog(tc,intcon,A,B,Aeq,Beq,lb,ub);

p = x(1); % no of potatoes
a = x(2); % no of apples

 disp('no of potatoes='); disp(p); 
 disp('no of apples='); disp(a);
 disp('total cost='); disp(tc);

