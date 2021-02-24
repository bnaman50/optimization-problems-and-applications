% NLP Example
% Covering maximum rectangle area with given fence material
% length and width are variables 
% Reference pg 1 of following document
% http://www.tkiryl.com/Calculus/Section_4.5--Optimization%20Problems/Optimization_Problems.pdf
function E5_Fence()
A = [];    B = [];    % Ax<=B
Aeq = [];  Beq = [];  % Aeq=Beq
LB = [0;0];   UB = [ ; ];   % lower bound and upper bound

x0 = [0.1;0.1];  % inital guess of length and width
% x = [length(l); width(w)]
% a - area covered by fence

[x,a,exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,LB,UB,@confun);

l = x(1); % length of the cuboid
w = x(2); % width of the cuboid

disp('length='); disp(l); 
disp('width='); disp(w);
disp('maximum rectangular area covered by fence='); disp(-a);
disp('exitflag='); disp(exitflag);
end

function f = objfun(x)
% function for defining objective function to be maximized
l = x(1); % length of the cuboid
w = x(2); % width of the cuboid

f = -(l*w); % area = length*width
end

function [C,Ceq] = confun(x)
% function for defining nonlinear constraints
l = x(1);   % length of the cuboid
w = x(2);   % width of the cuboid
p = 2400;   % perimeter (available fence material) = (length + 2*width)

C = [];          % C(x)<=0
Ceq = p-(l+(2*w)); % Ceq(x)=0
end
