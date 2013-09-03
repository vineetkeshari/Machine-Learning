% Fits and plots an n-th order polynomial for the data
function [] = curvefit (datax, datay, n, color, showPoints, pointSize)
    cfParams = polyfit(datax, datay, n);
    cfRange = min(datax):((max(datax)-min(datax))./100):max(datax);
    if showPoints == 1
        scatter (datax, datay, pointSize, 'black', 'filled');
        hold on;
    end
    plot (cfRange, polyval(cfParams, cfRange), 'LineWidth', 4, 'Color', color);
    if showPoints == 1
        hold off;
    end
end