function [x,y] = some_func(image)

[row,col] = size(image);
x = 0; y = 0; counter = 0;
for i = 1:row
    for j = 1:col
        if(image(i,j)>0)
            x = x+i;
            y = y+j;
            counter = counter+1;
        end
    end
end
x = floor(x/counter);
y = floor(y/counter);
