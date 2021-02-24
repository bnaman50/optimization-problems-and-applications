% Quadratic programming problem 
% Linear Regression

% Dataset
load accidents
x = hwydata(:,14); %Population of states
Y = hwydata(:,4); %Accidents per state

X = [ones(length(Y), 1), x];

% linear least-square problem 
[theta,resnorm,residual,exitflag] = lsqlin( X, Y, [], []);

% Visualize the regression by plotting the actual values Y and the calculated values yCalc
yCalc = X*theta;
scatter(x,Y)
hold on
plot(x,yCalc)
xlabel('Population of state', 'FontName', 'Cambria', 'FontSize', 11)
ylabel('Fatal traffic accidents per state', 'FontName', 'Cambria', 'FontSize', 11)
title('Linear Regression Relation Between Accidents & Population', 'FontName', 'Cambria', 'FontSize', 12)
grid on