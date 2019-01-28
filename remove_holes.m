function result_image = remove_holes(input_image)

%figure(1);imshow(input_image*255);

if(input_image(1,1) == 1)
input_image(:,:)=255;
%figure(2);imshow(input_image);
result_image=input_image;
else
largest = find_largest_component(~input_image);
%figure(2);imshow(~largest);
result_image = ~largest;
end