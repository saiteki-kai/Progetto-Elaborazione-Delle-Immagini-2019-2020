function [tracc tsacc] = confchart(train, test)

trcm = confusionchart(train.labels, train.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');
tracc = sum(diag(trcm.NormalizedValues))/numel(train.labels);
title("Train Accuracy: " + tracc);

figure;
tscm = confusionchart(test.labels, test.predicted, ...
    'RowSummary','row-normalized','ColumnSummary','column-normalized');
tsacc = sum(diag(tscm.NormalizedValues))/numel(test.labels);
title("Test Accuracy: " + tsacc);
end