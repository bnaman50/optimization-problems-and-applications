% INLP example
% Optimization of no of refrigerators unit produced giving minimum total cost 
% No of refrigerators produced is variable
% Reference - pg 352, example 2 of following book MAX S. PETERS & KLAUS
% D.TIMMERHAU. Plant Design and Economics for Chemical Engineers. 4th
% edition

function E10_inlp_refrigerator()
A = -[1]; B = -[0];     % AX <= B
Aeq = []; Beq = []; % AeqX = B
lb = [1]; ub = [1000];  % lower bound and upper bound
%x0 = [1];           % initial guess for no of refrigeartor unit produced

% x - no of refrigerator unit produced 
% fval - total minimum cost for x refrigerator units
nvrs=1;
intcon=1;
[x,fval,exitflag] = ga(@objfun,nvrs,[],[],[],[],lb,ub,@confun,intcon);

%x = int16(x);   % no of refrigerator unit must be integer
tc = fval*x;    % daily total cost
Ps = 173;       % selling price of refrigerator
P = (Ps*x)-(tc);% daily total profit

disp('no of refrigerators produced ='); disp(x);
disp('daily total minimum cost ='); disp(tc);
disp('daily profit ='); disp(P);
disp('exitflag ='); disp(exitflag);
end

function f = objfun(x)
Fc = 1750;              % daily fixed charges
Oe = 7325;              % daily other expences
Vc = 47.73+(0.1*x^1.2); % variable cost

% f - cost of one refrigerator unit
f = ((Fc+Oe)/x)+Vc;
end

function [C,Ceq] = confun(x)
C = [];
Ceq = [];
end