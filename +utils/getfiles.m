function files = getfiles(folderPath)
%GET_FILES Get files from a folder.

files = dir(folderPath);
files = files([files.isdir] == 0);
files = strcat(folderPath, '/', {files.name}');
end