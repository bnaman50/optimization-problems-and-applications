% NLP Example
% Minimum cost for atleast 50 m3 cuboid volume
% height and width are the variables
% Reference pg 3 of the following document
% http://www.tkiryl.com/Calculus/Section_4.5--Optimization%20Problems/Optimization_Problems.pdf

 function E2_Cuboid()
A = [];    B = [];    % Ax<=B
Aeq = [];  Beq = [];  % Aeq=beq
LB = [0;0];   UB = [ ; ];   % lower bound and upper bounds

% x = [width(w); height(h)]
x0 = [0.1;0.1];  % inital guess of width and height


[x,tc, exitflag] = fmincon(@objfun,x0,A,B,Aeq,Beq,LB,UB,@confun);

% tc - total cost
% given -> length = 3*width
% exitflag >0 ==> the solution is reliable

w = x(1); % width of the cuboid
h = x(2); % height of the cuboid
l=3*w;    % length of the cuboid
V=l*w*h;  % volume of the cuboid   

disp('width='); disp(w);
disp('height='); disp(h);
disp('length='); disp(l);
disp('volume='); disp(V);
disp('total cost='); disp(tc);
disp('exitflag='); disp(exitflag);
end
 
function f = objfun(x)
% function for defining objective function to be minimized

w = x(1); % width of the cuboid
h = x(2); % height of the cuboid
l=3*w; % length of the cuboid

%total cost= (surface area of top and bottom)*10
%                      + (suraface area of sides)*6
S1 = 2*l*w;                 % surface area of top and bottom   
S2 = 2*(l*h) + 2*(w*h);     % suraface area of sides
C1= 10; % unit cost of the material used in the top and bottom surface of the cuboid
C2= 6; % unit cost of the material used in the side surface of the cuboid

f = S1*C1 + S2*C2  ; % total material cost
end

function [C,Ceq] = confun(x)
% function for defining nonlinear constraints
w = x(1); % width of the cuboid
h = x(2); % height of the cuboid
l=3*w; % length of the cuboid

V = 50; % volume of the cuboid   

C = V-(l*w*h);  % C(x)<=0
Ceq = [];       % Ceq(x)=0
end
