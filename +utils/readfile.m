function out = readfile(path)
  f=fopen(path);
  l = textscan(f,'%s');
  out = l{:};
  fclose(f);
end