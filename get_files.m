function files = get_files(folder_path)
%GET_FILES Get files from a folder.

files = dir(folder_path);
files = files([files.isdir] == 0);
files = {files.name}';
end