function out = compute_homogenity(image)
     glcm = graycomatrix(image);
     stats = graycoprops(glcm, "homogeneity");
     out = stats.Homogeneity;
end

