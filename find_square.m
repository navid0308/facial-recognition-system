function [top,bottom,left,right] = find_square(max_row,max_col,row,col,width,height)

top = max(1,row-height/2);
bottom = min(max_row,row+height/2);
left = max(1,col-width/2);
right = min(max_col,col+width/2);