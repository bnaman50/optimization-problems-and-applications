% NLP example
% For given surface area, maximum cuboid volume
% Height and width of cuboid are variables 
% length is equal to width
% Reference pg 4 of following document
% http://www.tkiryl.com/Calculus/Section_4.5--Optimization%20Problems/Optimization_Problems.pdf

function E3_CuboidVolume()
A = [];    B = [];    % Ax<=B
Aeq = [];  Beq = [];  % Aeq=Beq
LB = [0;0];   UB = [ ; ];   % lower bound and upper bound

x0 = [0.1;0.1];  % inital guess of width and height
% x = [width(w); height(h)]
% V = volume of cuboid 

[x,V,exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,LB,UB,@confun);

% given -> length = width
w = x(1); % width of the cuboid
h = x(2); % height of the cuboid
l = w;    % length of the cuboid

disp('length='); disp(l); 
disp('width='); disp(w);
disp('height='); disp(h);
disp('Volume='); disp(-V);
disp('exitflag='); disp(exitflag);
end

function f = objfun(x)
% function for defining objective function to be maximized

w = x(1); % width of the cuboid
h = x(2); % height of the cuboid
l = w;    % length of the cuboid

% volume = length * width * height

f = -(l*w*h);
end

function [C,Ceq] = confun(x)
% function for defining nonlinear constraints

w = x(1); % width of the cuboid
h = x(2); % height of the cuboid
l = w;    % length of the cuboid
S = 10;   % surface area of the cuboid

Ceq =-S + 2*((l*w)+(l*h)+(w*h));        % Ceq(x)=0
C = [];                                 % C(x)<=0
end