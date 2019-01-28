load boosted;
load training;
myFolder = 'D:\Uni\CSE468\Project\data\test_cropped_faces';
ext = '.bmp';

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
    result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);
    result = result>max(result(:))/1.1;
    
    [M,lindex] = max(result(:));
    [R,C] = size(result);
    [row,col] = size(img);
    img = imread(fullFileName);
    if(M>0)
        for x = 1:R
            for y = 1:C
               if(result(x,y)>0)
               [top,bottom,left,right] = find_square(row,col,x,y,60,80);
               img = draw_rectangle(img, top, bottom, left, right);
               end
           end
        end
    end
    imwrite(uint8(img),strcat('D:\Uni\CSE468\Project\output\cropped\',num2str(k),'.png'));
    toc
end