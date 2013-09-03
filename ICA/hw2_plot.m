% Plots each element of data in realtime
function [] = hw2_plot (data, m, n)
    for i = 1:m
        for j = 1:n
            location = (i-1).*n + j;
            subplot(m,n,location);
            plot (data(:,i,j), 'LineWidth', 3, 'Color', 'r');
            title(sprintf('W(%d,%d)',i,j));
            xlabel('Iterations');
            ylabel('Value');
        end
    end
    drawnow;
end