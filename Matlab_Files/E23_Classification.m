function E23_Classification
% Non-linear programming
% Logistic Regression (Classification)

% load the dataset
load fisheriris

% training data
X = zeros(70, 4);
X(1:35, :) = meas(1:35, :); X(36:70, :) = meas(51:85, :);
y = ones(70, 1); y(1:35) = 0*y(1:35); % labels

% test data
Xtest = zeros(30, 4);
Xtest(1:15, :) = meas(36:50, :); Xtest(16:30, :) = meas(86:100, :);
ytest = ones(30, 1); ytest(1:15) = 0*ytest(1:15);

[m, n] = size(X);

X = [ones(m, 1) X];

% initial value of variables
initial_theta = zeros(n + 1, 1);

options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Compute accuracy on our training set
Xtest = [ones(size(Xtest, 1), 1) Xtest];
p = predict(theta, Xtest);

fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);

end

% classification of the test cases
function p = predict(theta, X)
p = X*theta;
p( p >= 0) = 1;
p( p < 0) = 0;

end

function g = sigmoid(z)
g = sigmf( z, [ 1, 0 ] );

end

% objective function along with its gradients 
function [J, grad] = costFunction(theta, X, y)

% Initialize some useful values
m = length(y); % number of training examples

z = X * theta;
h = sigmoid(z);
J =  ( -1/m ) * sum( y .* log( h ) + ( 1 - y ) .* log( 1 - h ) );
grad = ( X' * ( h - y ) ) / m;

end
