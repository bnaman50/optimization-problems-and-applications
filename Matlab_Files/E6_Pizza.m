% ILP example
% selling different types of pizza for maximum net income
% Reference http://home.ubalt.edu/ntsbarsh/opre640A/partVIII.htm
 
A = [4 2; 1 1;-1 0;0 -1]; B = [600;200;-50;-25]; % Ax<=B

Aeq = [0,0;0,0;0,0]; Beq = [0;0;0];  % Aeq=Beq

lb = [0,0]; ub = []; % lower bound and upper bound

% Net Income= no of regular pizza * 1 + no of deluxe pizza * 1.5
ni = -[1,1.5]; % ni(1) = net income from regular pizza
              % ni(2) = net income from deluxe pizza
              
x = [];  % x = [regular pizza(r); deluxe pizza(d)]

intcon = [1,2]; % no of regular pizza(x(1)) and deluxe pizza(x(2)) are integer

[x,ni,exitflag] = intlinprog(ni,intcon,A,B,Aeq,Beq,lb,ub);

r = x(1); % no of regular pizza
d = x(2); % no of deluxe pizza

disp('No of Regular Pizza='); disp(r); 
disp('No of Deluxe Pizza='); disp(d);
disp('Net Income='); disp(-ni);
disp('exitflag='); disp(exitflag);