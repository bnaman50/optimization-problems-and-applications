% NLP example
% Optimization of insulation material thickness over a pipe 
% Insulation thickness is variable
% Reference pg 430, problem 2 of following book "PLANT DESIGN AND ECONOMICS
% FOR CHEMICAL ENGINEERS" BY MAX S. PETERS and KLAUS D.TIMMERHAUS

function E8_Insulation_thickness()
A = []; B = [];     % Ax <= B
Aeq = []; Beq = []; %AeqX = Beq
LB = [0]; UB = [];   % lower bound and upper bound
x0  = [0];           % initial guess 
% x - insulation thickness
% fval - optimum cost

[x,fval,exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,LB,UB);

disp('optimum insulation thickness'); disp(x); 
disp('total minimum cost'); disp(fval); 
disp('exitflag'); disp(exitflag);
end

function f = objfun(x)
Do = 10.75; % outside diameter of pipe (inch)
T1 = 400;   % temperature of the steam (°F)
T2 = 70;    % temperature of the surrounding (in °F)
k = 0.03;   % thermal conductivity of insulation material (Btu/(h)(ft2)(°F/ft))
P = 4500;   % price of installed insulation per unit thickness of insulation ($/inch)
L = 1000;   % total length of pipe (ft)
h = 2;      % air-film heat transfer coefficient (Btu/(h)(ft2)(°F))
Hs = 826;   % Latent heat of steam at 400°F (Btu/lb)
Ps = 1.8;   % Price of steam per 1000 lb ($)

Ci = P*x;       % total cost of insulation material
Caf = 0.2*Ci;   % annual fixed cost including maintenance (20% of the Ci)

d = Do+2*x; % outside diameter after adding insulation
R1 = (log(d/Do))/(2*pi*L*k) ; % resistance by isulation material
R2 = 1/(h*pi*(d/12)*L) ;     % resistance by air-film

Cs = ((T1-T2)/(R1+R2))*((24*365*Ps)/(1000*826)); % total cost of steam annually

f = Ci+Caf+Cs; % Total annual cost 
end