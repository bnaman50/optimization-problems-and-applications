% LP example
% Optimization of feed flow rate to three reactor units giving maximum profit 
% Flow rate to three reactor units are variables
% Reference - pg 6 of following document - http://ukmk11.ogu.edu.tr/arsiv/ukmk6/sunu/PSM010.pdf

function E12_stream_split()
A = [1,0,0,0,0,0;
     0,1,0,0,0,0;
     0,0,1,0,0,0;
     0,0,0,1,0,0;
     0,0,0,0,1,0;
     0,0,0,0,0,1];

 B = [5000;5000;5000;10000;4000;7000];     % AX <= B

Aeq = []; Beq = [];            % AeqX = Beq
lb = [0;0;0;0;0;0]; ub = [5000;5000;5000;10000;4000;7000];   % lower and upper bound
x0 = [0;0;0;0;0;0];            % initial guess

% x = [FA,FB,FC,F,P1,P2]
% fval = daily profit

[x,fval,exitflag] =fmincon(@objfun,x0,A,B,Aeq,Beq,lb,ub,@confun);

FA = x(1);  % inlet feed to unit1
FB = x(2);  % inlet feed to unit2
FC = x(3);  % inlet feed to unit3
F = x(4);   % total inlet feed
P1 = x(5);  % outlet flow of product1
P2 = x(6);  % outlet flow of product2

disp('inlet feed to unit1 ='); disp(FA);
disp('inlet feed to unit2 ='); disp(FB);
disp('inlet feed to unit3 ='); disp(FC);
disp('total inlet feed ='); disp(F);
disp('outlet flow of product1 ='); disp(P1);
disp('outlet flow of product2 ='); disp(P2);
disp('maximum daily profit ='); disp(-fval);
disp('exitflag ='); disp(exitflag);
end

function f = objfun(x)
F = x(4);   % total inlet feed
P1 = x(5);  % outlet flow of product1
P2 = x(6);  % outlet flow of product2

Cf = 0.4*F;     % cost of feed
I1 = 0.6*P1;    % income from product 1
I2 = 0.5*P2;    % income from product 2

f = -((I1+I2)-Cf);
end

function [C,Ceq] = confun(x)
FA = x(1);  % inlet feed to unit1
FB = x(2);  % inlet feed to unit2
FC = x(3);  % inlet feed to unit3
F = x(4);   % total inlet feed
P1 = x(5);  % outlet flow of product1
P2 = x(6);  % outlet flow of product2

C  = [];    % C(x)<+0

con1 = -F+(FA+FB+FC);
con2 = -P1+((0.4*FA)+(0.3*FB)+(0.5*FC));
con3 = -P2+((0.6*FA)+(0.7*FB)+(0.5*FC));

Ceq = [con1,con2,con3]; % Ceq(x)=0
end