function out = computehog(im)
    out = extractHOGFeatures(im, 'CellSize', [16 16]);
end