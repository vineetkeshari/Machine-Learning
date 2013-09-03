% Fits and plots an n-th order polynomial for the data
function [] = curvefit (datax, datay, n, color, showPoints, pointSize)
    cfParams = polyfit(datax, datay, n);
    cfRange = min(datax):((max(datax)-min(datax))./100):max(datax);
    plot (cfRange, polyval(cfParams, cfRange), 'LineWidth', 5, 'Color', color);
    if showPoints == 1
        hold on;
        scatter (datax, datay, pointSize, 'black', 'filled');
        hold off;
    end
end