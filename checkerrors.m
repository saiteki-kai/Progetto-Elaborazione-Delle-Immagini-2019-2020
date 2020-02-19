function errors = checkerrors(im, centers, radius)
%CHECK_ERRORS ...

if ~isinteger(im)
    error("L'immagine deve essere RGB");
end

centers = centers * 5;
radius = radius * 5;

[n, m, ~] = size(centers);
if n == 6 && m == 4
    errors = checkrectangle(im, centers, radius);
else
    errors = checksquare(im, centers, radius);
end

end

function errors = checksquare(im, centers, radius)
%CHECKSQUARE

errors = [];
nStamps = 0;
for i = 1 : length(centers)
    if nStamps == 24, break, end
    
    x = centers(i, 1);
    y = centers(i, 2);
    choco = utils.cropcircle(im, x, y, radius, true);
    choco = imresize(choco, [239 239]);
    if getcode(choco) == 1
        nStamps = nStamps + 1;
    else
        x = centers(i, 1);
        y = centers(i, 2);
        errors = [errors; x y];
    end
end

if  nStamps == 24
    errors = [];
end

end

function errors = checkrectangle(im, centers, radius)
%CHECKRECTANGLE 

[n, m, ~] = size(centers);
grid = zeros(n, m);
for i = 1 : n
    for j = 1 : m
        x = centers(i, j, 1);
        y = centers(i, j, 2);
        choco = utils.cropcircle(im, x, y, radius, true);
        choco = imresize(choco, [239 239]);
        grid(i, j) = getcode(choco);
    end
end

conf1 = [
    2, 2, 2, 2, 2, 2;
    1, 1, 1, 1, 1, 1;
    1, 1, 1, 1, 1, 1;
    3, 3, 3, 3, 3, 3;
];

conf2 = [
    3, 3, 3, 3, 3, 3;
    1, 1, 1, 1, 1, 1;
    1, 1, 1, 1, 1, 1;
    2, 2, 2, 2, 2, 2;
];

p1 = grid == conf1';
p2 = grid == conf2';

if sum(p1 == 0, 'all') <= sum(p2 == 0, 'all')
    grid = p1;
else
    grid = p2;
end

errors = [];
for i = 1 : n
    for j = 1 : m
        if grid(i, j) == 0
            x = centers(i, j, 1);
            y = centers(i, j, 2);
            errors = [errors; x y];
        end
    end
end
end

function out = getcode(choco)
%GETCODE associates a code to a choco type

chocoType = classification.getchocotype(choco);

if chocoType == "ferrero_rocher" && existsstamp(choco)
    out = 1;
elseif chocoType == "ferrero_noir"
    out = 2;
elseif chocoType == "raffaello"
    out = 3;
else
    out = 4;
end

end


%%%%% AUMENTARE IL RAGGIO DEI CERCHI PER I BOLLINI FUORI RENGE %%%%%....
function out = existsstamp(im)
%ISSTAMP verify the existence of the stamp

hsv = rgb2hsv(im);
lab = rgb2lab(im);

S = hsv(:,:,2);
b = lab(:,:,3);
B = im(:,:,3);

b = (b + 128) / 255;

S = S > graythresh(S);
b = b > graythresh(b);
B = B < graythresh(B);

I1 = ~(S | b | B);

I = imopen(I1, strel('disk', 5));
if any(I(:))
    I = bwareafilt(I, 1);
    out = sum(I(:)) > 350;%381
else
    out = false;
end
end

