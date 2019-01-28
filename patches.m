function [img_array,x] = patches(img)
[row,col] = size(img);
r = 1;
x=1;
while ((r+59) <= row)
  c = 1;
  while ((c+49) <= col)
     img_array(:,:,x) = img(r:(r+59),c:(c+49));
     c = c+50;
     x=x+1;
  end
  r = r+60;
end