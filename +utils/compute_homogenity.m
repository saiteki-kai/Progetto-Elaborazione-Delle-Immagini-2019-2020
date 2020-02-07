function out = compute_homogenity(image)
     glcm = graycomatrix(image);
     out = graycoprops(glcm, "homogeneity");
end

