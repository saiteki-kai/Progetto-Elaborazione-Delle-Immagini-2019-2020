% mostra ellisse bounding box
% passandogli il vettore s calcolabile con regionprops(...)
% - bounding box
% - eccentricity, orientation, centroid
% - majoraxis, minoraxis

function showellipse(image, mask, showimage)
    
    s = regionprops(mask, 'BoundingBox', 'Eccentricity', 'MajorAxisLength', ...
        'MinorAxisLength', 'Orientation', 'Centroid');
    
    if (showimage)
        imshow(image);
        hold on;
    end
    
    rectangle('Position', s.BoundingBox, 'EdgeColor', 'r');

    phi = linspace(0,2*pi,50);
    cosphi = cos(phi);
    sinphi = sin(phi);

    for k = 1:length(s)
        xbar = s(k).Centroid(1);
        ybar = s(k).Centroid(2);

        a = s(k).MajorAxisLength/2;
        b = s(k).MinorAxisLength/2;

        theta = pi*s(k).Orientation/180;
        R = [ cos(theta)   sin(theta)
             -sin(theta)   cos(theta)];

        xy = [a*cosphi; b*sinphi];
        xy = R*xy;

        x = xy(1,:) + xbar;
        y = xy(2,:) + ybar;
        
        dist = vecnorm(xy)';
        
        x = x';
        y = y';
        
        [~, ii] = maxk(dist, 3);
        [~, jj] = mink(dist, 2);
        plot(x(ii), y(ii));
        plot(x(jj), y(jj));

        scatter(x, y);
    end
    
    hold off

end
