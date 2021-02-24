% NLP example
% Optimization of Cylinder
% Radius and height of cylinder are variables
% Reference pg 5 of following document
% http://www.tkiryl.com/Calculus/Section_4.5--Optimization%20Problems/Optimization_Problems.pdf

function E1_Cylinder()

A=[];  B=[];       % AX<=B
Aeq=[];  Beq=[];   % AeqX=Beq
LB = [0;0]; UB=[;]; % lower bound and upper bounds
% x=[radius(r);height(h)]    
% fval - surface area of Cylinder 
% V - Volume of cylinder

x0 = [0.1;0.1]; % x0 = initial guess radius and height

[x,fval,exitflag] = fmincon(@objfun, x0, A,B,Aeq,Beq,LB,UB,@confun);

r = x(1); % radius of cylinder
h = x(2); % height of cylinder

disp('Radius of cylinder='), disp(r);
disp('Height of cylinder='), disp(h);
disp('Surface area of cylinder='), disp(fval);
disp('exitflag='); disp(exitflag);
end


function f = objfun(x)
 % function for defining objective function to be minimized
 
r = x(1); % radius of cylinder
h = x(2); % height of cylinder

f =2*pi*r*h+2*pi*r^2;  % f - surface area of cylinder
end

function [C, Ceq] = confun(x)
% function for defining nonlinear constraints
 
r = x(1); % radius of cylinder
h = x(2); % height of cylinder

V=10; % volume of cylinder
C = V-(pi*h*r^2); % C(x)<=0
Ceq=[];           % Ceq(x)=0
end