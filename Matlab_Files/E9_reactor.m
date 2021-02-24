% NLP Example
% determine the volume of two reactors in series to maximize the concentration of B leaving from reactor 2
% exit concentration of A and B and volume of both the reactors are variables
% Reference pg 7 of the following document - 
% http://www.academia.edu/5332657/Efficient_constraint_handling_scheme_for_differential_evolutionary_algorithm_in_solving_chemical_engineering_optimization_problem

function E9_reactor()
A = [];    B = [];    % Ax<=B
Aeq = []; Beq = [];     % Aeq=Beq

lb = [0,0,0,0.00001,0.00001];   % lower bound
ub = [1,1,1,16,16];   % upper bound
x0 = [0,0,0,0,0];   
% x0 ->  inital guess of concentration of A & B leaving both the reactors
%        and volumes of both reactor 1 and 2

[x,fval,exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,lb,ub,@confun);

Ca1 = x(1);     % concentration of A leaving from reactor 1
Ca2 = x(2);     % concentration of A leaving from reactor 2
Cb1 = x(3);     % concentration of B leaving from reactor 1
V1 = x(4);      % volume of reactor 1
V2 = x(5);      % volume of reactor 2
Cb2 = -fval;    % concentration of B leaving from reactor 2

disp('concentration of A leaving from reactor 1 (Ca1) =');disp(Ca1);
disp('concentration of A leaving from reactor 2 (Ca2) =');disp(Ca2);
disp('concentration of B leaving from reactor 1 (Cb1) =');disp(Cb1);
disp('maximum concentration of B leaving from reactor 2 (Cb2) =');disp(Cb2);
disp('optimized volume of reactor 1 (V1) =');disp(V1);
disp('optimized volume of rector 2 (V2) =');disp(V2);
disp('exitflag =');disp(exitflag);
end

function f = objfun(x)

k1 = 0.09755988;    % rate constant for reaction A -> B in reactor 1
k2 = 0.99*k1;       % rate constant for reaction A -> B in reactor 2
k3 = 0.0391908;     % rate constant for reaction B -> C in reactor 1
k4 = 0.9*k3;        % rate constant for reaction B -> C in reactor 2

Ca1 = x(1);     % concentration of A leaving from reactor 1
Ca2 = x(2);     % concentration of A leaving from reactor 2
Cb1 = x(3);     % concentration of B leaving from reactor 1
V1 = x(4);      % volume of reactor 1
V2 = x(5);      % volume of reactor 2

Cb2 = ((Cb1-Ca2+Ca1)/(1+(k4*V2)));

f= -Cb2;        % concentration of B leaving from reactor 2
end

function [C,Ceq] = confun(x)

k1 = 0.09755988;    % rate constant for reaction A -> B in reactor 1
k2 = 0.99*k1;       % rate constant for reaction A -> B in reactor 2
k3 = 0.0391908;     % rate constant for reaction B -> C in reactor 1
k4 = 0.9*k3;        % rate constant for reaction B -> C in reactor 2

Ca1 = x(1);     % concentration of A leaving from reactor 1
Ca2 = x(2);     % concentration of A leaving from reactor 2
Cb1 = x(3);     % concentration of B leaving from reactor 1
V1 = x(4);      % volume of reactor 1
V2 = x(5);      % volume of reactor 2

C = -4+((x(4)^0.5)+(x(5)^0.5)); % C(x)<=0

con1 = -1+((1+(k1*V1))*Ca1);
con2 = -x(1)+(1+(k2*V2))*Ca2;
con3 = -1+x(1)+(1+(k3*V1))*Cb1;

Ceq = [con1,con2,con3];        % Ceq(x)=0
end   