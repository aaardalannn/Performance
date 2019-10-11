% x = 1:100;                                          % Create Independent Variable
% y = randn(50,100);       
% Create Dependent Variable ?Experiments? Data
function n5er(x,y)
N = size(y,1);                                      % Number of ?Experiments? In Data Set
yMean = mean(y);                                    % Mean Of All Experiments At Each Value Of ?x?
ySEM = std(y)/sqrt(N);                              % Compute ?Standard Error Of The Mean? Of All Experiments At Each Value Of ?x?
CI95 = tinv([0.025 0.975], N-1);                    % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));              % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ?x?
figure

plot(x, yMean,'r-','linewidth',2)                                      % Plot Mean Of All Experiments
hold on

y2=yCI95+yMean;
ciplot(y2(1,:),y2(2,:),x)
% plot(x, y2(1,:),'r--') 
% plot(x, y2(2,:),'r--') 
% Plot 95% Confidence Intervals Of All Experiments
hold off
grid