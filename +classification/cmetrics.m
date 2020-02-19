function [accuracy, recall, precision] = cmetrics(gt, predicted)
%CMETRICS calcola le metriche di valutazione per la conformità

cm = confusionmat(gt, predicted);

nClasses = length(unique(gt));

precision = 1;
recall = 1;
for i=1:nClasses
    prec = 0;
    if sum(cm(:, i)) ~= 0
        prec = cm(i,i) / sum(cm(:, i));
    end
    
    rec = 0;
    if sum(cm(i, :)) ~= 0
        rec = cm(i,i) / sum(cm(i, :));
    end
    
    precision = precision * prec;
    recall = recall * rec;
end

accuracy = sum(diag(cm)) / numel(gt);

end
