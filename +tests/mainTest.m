images = utils.getfiles("Acquisizioni/");

counter = 0; 
for i=1:numel(images)
    im = imread(images{i});
    main(im);
    return;
    %counter = counter + main(im);
end
disp(counter);