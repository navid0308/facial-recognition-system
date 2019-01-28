function img_array = read_all_images(myFolder,ext,type)
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern = fullfile(myFolder, strcat('*',ext));
Files = dir(filePattern);

i = 1;
for k = 1:length(Files)
  baseFileName = Files(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  img = read_gray(fullFileName);
  if(strcmp(type,'nonface'))
      [row,col] = size(img);
      r = 1;
      while ((r+59) <= row)
        c = 1;
        while ((c+49) <= col)
           img_array(:,:,i) = img(r:(r+59),c:(c+49));
           i = i+1;
           c = c+50;
        end
        r = r+60;
      end
  elseif(strcmp(type,'face'))
      img_array(:,:,i) = img(30:89,26:75);
      i = i+1;
  end
  
end