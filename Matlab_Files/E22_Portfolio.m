function E22_Portfolio
% Quadratic Programming Problem
% Portfolio Optimization

% load the dataset
load('port5.mat','Correlation','stdDev_return','mean_return')

%mean_return_full = mean_return;
%stdDev_return_full = stdDev_return;
%Correlation_full = Correlation;

%mean_return = mean_return(1:225);
%stdDev_return = stdDev_return(1:225);
%Correlation = Correlation(1:225, 1:225);

% Calculate covariance matrix from correlation matrix
Covariance = Correlation .* (stdDev_return * stdDev_return');

nAssets = numel(mean_return); r = 0.002;     % number of assets and desired return

Aeq = ones(1,nAssets); beq = 1;              % equality Aeq*x = beq
Aineq = -mean_return'; bineq = -r;           % inequality Aineq*x <= bineq
lb = zeros(nAssets,1); ub = ones(nAssets,1); % bounds lb <= x <= ub
c = zeros(nAssets,1);                        % objective has no linear term; set it to zero

options = optimoptions('quadprog', 'Algorithm', 'interior-point-convex');
options = optimoptions(options, 'TolFun', 1e-10);
[x1, fval1, exitflag1] = quadprog(Covariance, c, Aineq, bineq, ...
                                  Aeq, beq, lb, ub, [], options);

% plot results
plotPortfDemoStandardModel(x1)

% Add group constraints to existing equalities
Groups = blkdiag(ones(1,nAssets/3), ones(1,nAssets/3), ones(1,nAssets/3));
Aineq = [Aineq; -Groups];         % convert to <= constraint 
bineq = [bineq; -0.3*ones(3,1)];  % by changing signs
 
[x2, fval2, exitflag2] = quadprog(Covariance, c, Aineq, bineq, ...
                                  Aeq, beq, lb, ub, [], options);

% Plot results, superimposed on results from previous problem.
plotPortfDemoGroupModel(x1,x2);

end

function plotPortfDemoGroupModel(x1,x2)
% Copyright 2010 The MathWorks, Inc.

% Create figure
figure2 = figure;

% Create axes
axes1 = axes('Parent',figure2,'XTick',[1 75 150 225]);
xlim(axes1,[1 230]);
ylim(axes1,[0 0.3]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');

% Plot bars (standard model); increase width a little so that bars can be
% seen behind the group model's bars
bar(x1,'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'BarWidth',2.5,...
    'Parent',axes1,...
    'DisplayName','Standard');

% Plot bars (model with group constraints)
idx = find(x2>.00001); % don't plot negligiblely small elements of solution
bar(idx,x2(idx),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'BarWidth',1.5,...
    'Parent',axes1,...
    'DisplayName','With group constraints');

% Create xlabel
xlabel('Assets', 'FontName', 'Cambria' );
% Create ylabel
ylabel('Fraction of investment', 'FontName', 'Cambria');
% Create title
title('225-asset problem', 'FontName', 'Cambria', 'FontSize', 12)

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.454285714285709 0.714285714285715 0.417857142857143 0.1]);

% Create textbox
annotation(figure2,'textbox',...
    [0.195642857142857 0.863920537540176 0.107928571428571 0.0595238095238109],...
    'String',{'Group 1'},...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure2,'textbox',...
    [0.465642857142857 0.863920537540176 0.107928571428571 0.0595238095238109],...
    'String',{'Group 2'},...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure2,'textbox',...
    [0.722655844155843 0.863920537540176 0.107928571428571 0.0595238095238109],...
    'String',{'Group 3'},...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create doublearrow
annotation(figure2,'doublearrow',[0.132142857142857 0.380952380952381],...
    [0.870428571428572 0.871165644171779],'Color',[0 0.498039215803146 0]);

% Create doublearrow
annotation(figure2,'doublearrow',[0.39142857142857 0.641071428571428],...
    [0.870428571428572 0.871165644171779],'Color',[0 0.498039215803146 0]);

% Create doublearrow
annotation(figure2,'doublearrow',[0.648928571428569 0.898571428571426],...
    [0.870428571428572 0.871165644171779],'Color',[0 0.498039215803146 0]);

end

function plotPortfDemoStandardModel(x1)
% Copyright 2010 The MathWorks, Inc.

figure;
bar1 = bar(x1,'FaceColor','b','EdgeColor','b');
set(bar1,'BarWidth',2);
set(gca,'xlim',[1 ( length(x1)+5 )])
set(gca,'ylim',[0 0.3])
set(gca,'xTick',[1 75 150 225]);
title('Standard model - 225-asset problem', 'FontName', 'Cambria', 'FontSize', 12)
xlabel('Assets', 'FontName', 'Cambria')
ylabel('Fraction of investment', 'FontName', 'Cambria')
grid on

end