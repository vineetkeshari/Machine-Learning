% Fits and plots an n-th order polynomial for the data
function [] = hw2_curvefit (data, n)
    cfParams = polyfit(data(1,:), data(2,:), n);
    cfRange = min(data(1,:)):(max(data(1,:))-min(data(1,:)))./100:max(data(1,:));
    plot (cfRange, polyval(cfParams, cfRange), 'LineWidth', 3, 'Color', 'b');
    xlabel ('x times input signals');
    ylabel ('Root mean squared error');
    title ('Accuracy vs no. of mixed signals');
    hold on;
    scatter (data(1,:), data(2,:), 100, 'g', 'filled');
    hold off;
end