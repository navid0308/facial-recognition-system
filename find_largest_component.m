function result = find_largest_component(image)

[labels, number] = bwlabel(image, 8);
if(number == 0)
    [row,col] = size(image);
    result = zeros(row,col);
else
    counters = zeros(1,number);
    for i = 1:number
        component_image = (labels == i);
        counters(i) = sum(component_image(:));
    end
    [~, id] = max(counters);    
    result = double(labels == id);
end