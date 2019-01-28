function TESTER(myFolder, ext, destination)

load boosted;
load threshold;
load training;

negative_histogram = read_double_image('negatives.bin');
positive_histogram = read_double_image('positives.bin');

filePattern = fullfile(myFolder, strcat('*',ext));
Files = dir(filePattern);

for k = 1:length(Files)
    tic;
    baseFileName = Files(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    
    image = imread(fullFileName);
    SKIN = detect_skin(image,positive_histogram,negative_histogram);
    SKIN = SKIN > max(SKIN(:))/2;
    SKIN = imdilate(SKIN,ones(3,3));
    SKIN = remove_holes(SKIN);
    
    img = read_gray(fullFileName);
    img = img .* SKIN;
    img = imresize(img,0.5,'bilinear');
    
    S = 0.5;
    SC = S;
    S = S+0.2;
    while S<3.5
        SC(end+1) = S;
        S = S+0.5;
    end
    %[result,max_scales] = multiscale_correlation(img,boosted_classifier,SC);
    %save('R','result');
    [result,max_scales] = boosted_multiscale_search(img,SC,boosted_classifier,weak_classifiers,[60 50]);
    %result = result>threshold;
    result = imresize(result,2,'bilinear');
    max_scales = imresize(max_scales,2,'bilinear');
    result = result>(max(result(:))/1.5);
    I = find_largest_component(result);
    I = result .* I;
    [X, Y] = some_func(I);
    change = 1;
    
    while(change>=0.7)
        result = result .* ~I;
        I = find_largest_component(result);
        if(sum(result(:))>0)
            I = result .* I;
            [temp_x, temp_y] = some_func(I);
            dist = sqrt((X(end)-temp_x).^2 + (Y(end)-temp_y).^2);
            change = dist/(max_scales(temp_x,temp_y)*100);
            if(change>=0.7)
                X(end+1)=temp_x;
                Y(end+1)=temp_y;
            end
        else
            change = 0;
        end
    end
    
    img = imread(fullFileName);
    [row,col] = size(img);
    for i = 1:length(X)
        if(isnan(X(i)) || isnan(Y(i)))
            break;
        end
        x = X(i);
        y = Y(i);
        [top,bottom,left,right] = find_square(row,col,x,y,70*max_scales(x,y),80*max_scales(x,y));
        img = draw_rectangle(floor(img), floor(top), floor(bottom), floor(left), floor(right));
    end
    %{
    temp = result;
    while(sum(temp(:))>0)
        result = temp;
        temp = imerode(result,ones(3,3));
    end
    
    [R,C] = size(result);
    [row,col] = size(img);
    img = imread(fullFileName);
    %img = imresize(img,1/2,'bilinear');
    for x = 1:R
        for y = 1:C
           if(result(x,y)>0)
               [top,bottom,left,right] = find_square(row,col,x,y,30/max_scales(x,y),50/max_scales(x,y));
               img = draw_rectangle(floor(img), floor(top), floor(bottom), floor(left), floor(right));
           end
        end
    end
    %}
    imwrite(uint8(img),strcat(destination,num2str(k),'.png'));
    toc
end