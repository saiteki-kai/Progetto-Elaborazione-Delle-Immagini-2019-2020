function out = normalize2(in)
N = length(in);

% exclude possible outliers
O = N * 0.05;
[maxVal, ~] = mink(in, O);
[minVal, ~] = maxk(in, O);
in = in(~ismember(in, [maxVal, minVal]));

out = (in - min(in)) ./ (max(in) - min(in));
end