function out = readfile(path)
  f=fopen(path);
  l = textscan(f,'%s','delimiter', '\n');
  out = l{:};
  fclose(f);
end