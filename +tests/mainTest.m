images = utils.getfiles("Acquisizioni/");


% SERVE GROUNDTTHR^U T PER VALUTARE FP,FN,TP,...

counter = 0; 
for i=1:numel(images)
    im = imread(images{i});
   
    counter = counter + main(im);
end
disp(counter);