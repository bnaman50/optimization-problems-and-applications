% LP example
% Optimization of feed flow rate two crude oils giving maximum profit 
% Flow rate of two crude oils are variable
% Reference - pg 5 of following document - http://ukmk11.ogu.edu.tr/arsiv/ukmk6/sunu/PSM010.pdf

function E11_crude()
A = [-1,0,0,0,0; 
     0,-1,0,0,0;
     0,0,1,0,0;
     0,0,0,1,0;
     0,0,0,0,1]; 
B = [0;0;6000;2400;8000];       % AX<=B

Aeq = [0.70,0.31,-1,0,0;
       0.06,0.09,0,-1,0;
       0.24,0.60,0,0,-1]; 
Beq = [0;0;0];                  % AeqX = Beq

lb = [0;0;0;0;0]; ub = [ ; ];   % lower and upper bound
x0 = [0;0;0;0;0];               % initial guess of flow rates

% f1 - flow rate of crude #1
% f2 - flow rate of crude #2
% Ag - total ammount of gasoline 
% Ak - total ammount of kerosene 
% Af - total ammount of fuel oil

% x = [f1;f2;Ag;Ak;Af]
% tp = total maximum profit

[x,tp,exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,lb,ub);

f1 = x(1);  % flow rate of crude #1 (bbl/day)
f2 = x(2);  % flow rate of crude #2 (bbl/day)

disp('optimum flow rate of crude #1 (bbl/day) ='); disp(f1);
disp('optimum flow rate of crude #2 (bbl/day) ='); disp(f2);
disp('total maximum profit($) ='); disp(-tp);
disp('exitflag ='); disp(exitflag);
end

function f = objfun(x)
cc1 = 24;   % cost of crude#1 ($/bbl)
cc2 = 15;   % cost of crude#2 ($/bbl)
Pg = 36;    % sales price of gasoline ($/bbl)
Pk = 24;    % sales price of kerosene ($/bbl)
Pf = 21;    % sales price of fuel oil ($/bbl)
f1 = x(1);  % flow rate of crude #1 (bbl/day)
f2 = x(2);  % flow rate of crude #2 (bbl/day)
Ag = x(3);  % total ammount of gasoline (bbl/day)
Ak = x(4);  % total ammount of kerosene (bbl/day)
Af = x(5);  % total ammount of fuel oil (bbl/day)

ti = (Ag*Pg)+(Ak*Pk)+(Af*Pf); % total income = amount(bbl/day)*sales price($/bbl)

tc = (f1*cc1)+(f2*cc2);% total cost = amount of crude(bbl/day)*costof crude($/bbl)

tp = (ti-tc); % tp - total profit
f = -tp;
end