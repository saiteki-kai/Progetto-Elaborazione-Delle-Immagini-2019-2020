function chocoType = getchocotype(im)
%GETCHOCOTYPE

color = classification.getcolor(im);
isreject = classification.isreject(im);

if isreject
    chocoType = "rigetto";
else
    switch color
        case "dorato"
            chocoType = "ferrero_rocher";
        case "nero"
            chocoType = "ferrero_noir";
        case "bianco"
            chocoType = "raffaello";
    end
end

end