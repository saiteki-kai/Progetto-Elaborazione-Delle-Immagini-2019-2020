function [accuracy, recall, precision, recallRigetto] = metrics(gt, predicted)

cm = confusionmat(gt, predicted, 'order', ["ferrero_rocher","ferrero_noir","raffaello", "rigetto"]);

precision = 1;
recall = 1;
for i=1:4
    prec = cm(i,i) / sum(cm(:, i));
    rec = cm(i,i) / sum(cm(i, :));
    
    precision = precision * prec;
    recall = recall * rec;
    % disp(i+") prec: " + precision + ", rec: " + recall);
end

recallRigetto = cm(4,4) / sum(cm(4, :));

accuracy = sum(diag(cm)) / numel(gt);

end