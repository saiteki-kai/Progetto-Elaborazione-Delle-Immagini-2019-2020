function shape = getshape(box, mask)
%CIAO Summary of this function goes here
%   Detailed explanation goes here
e = regionprops(mask, 'Eccentricity');
if (e.Eccentricity < 0.53)
    disp("quadrato");
    folder = "TrainingSet/Quadrate";
    % continue;
shape = "square";
else
    folder = "TrainingSet/Rettangolari";
    disp("rettangolo");
shape = "rectangle";
    % grid = create_grid(centers);
end
end

