% NLP example
% Maximum volume of cuboid made by using a Cardboard
% Height of the cuboid is variable 
% Reference pg 6 of following document
% http://www.tkiryl.com/Calculus/Section_4.5--Optimization%20Problems/Optimization_Problems.pdf

function E4_Cardboard()
A = [];    B = [];    % Ax<=B
Aeq = [];  Beq = [];  % Aeq=Beq
LB = [0];   UB = [5];   % lower bound and upper bound

% x = [width(w); height(h)]

x0 = [0];  % inital guess of height

% x = [height(h)]
% V = volume of cuboid 

[x,V,exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,LB,UB);

h=x;        % height of the cuboid
l = 10-2*x; % length of the cuboid
w = 14-2*x; % width of the cuboid

disp('length='); disp(l); 
disp('width='); disp(w);
disp('height='); disp(h);
disp('Volume='); disp(-V);
disp('exitflag='); disp(exitflag);
end

function f = objfun(x)
% function for defining objective function to be maximized
h=x;        % height of the cuboid
l = 10-2*x; % length of the cuboid
w = 14-2*x; % width of the cuboid

% volume = length * width * height

f = -(l*w*h);
end