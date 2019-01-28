function result = draw_rectangle(frame, top, bottom, left, right)

[rows, cols] = size(frame);
left = max(2, left);
left = min(cols-1, left);
right = max(2, right);
right = min(cols-1, right);
top = max(2, top);
top = min(rows-1, top);
bottom = max(2, bottom);
bottom = min(rows-1, bottom);

result = frame;

[~,~,bands]=size(result);

if(bands>1)
result(top:bottom, [(left-1):(left+1), (right-1):(right+1)],1) = 255;
result(top:bottom, [(left-1):(left+1), (right-1):(right+1)],2) = 255;
result(top:bottom, [(left-1):(left+1), (right-1):(right+1)],3) = 0;

result([(top-1):(top+1), (bottom-1):(bottom+1)], left:right,1) = 255;
result([(top-1):(top+1), (bottom-1):(bottom+1)], left:right,2) = 255;
result([(top-1):(top+1), (bottom-1):(bottom+1)], left:right,3) = 0;
else
result(top:bottom, [(left-1):(left+1), (right-1):(right+1)]) = 255;

result([(top-1):(top+1), (bottom-1):(bottom+1)], left:right) = 255;
end