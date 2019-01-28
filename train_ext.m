[cascaded_classifiers,cascaded_weak_classifiers,thresholds] = get_cascade;
false_negatives = 0;
moved = 0;
load fm;
myFolder = 'D:\Uni\CSE468\Project\data\training_faces';
ext = '.bmp';

negative_histogram = read_double_image('negatives.bin');
positive_histogram = read_double_image('positives.bin');

filePattern = fullfile(myFolder, strcat('*',ext));
Files = dir(filePattern);
Files = Files(randperm(length(Files))); %randomize
total = 0;

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
    
    boosted_classifier = cascaded_classifiers{1};
    weak_classifiers = cascaded_weak_classifiers{1};
    result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);
    if(max(result(:))>thresholds{1})
        boosted_classifier = cascaded_classifiers{2};
        weak_classifiers = cascaded_weak_classifiers{2};
        result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);
        if(max(result(:))>thresholds{2})
            boosted_classifier = cascaded_classifiers{3};
            weak_classifiers = cascaded_weak_classifiers{3};
            result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);
            if(max(result(:))>thresholds{3})
                boosted_classifier = cascaded_classifiers{4};
                weak_classifiers = cascaded_weak_classifiers{4};
                result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);
                if(max(result(:))>thresholds{4})
                    boosted_classifier = cascaded_classifiers{5};
                    weak_classifiers = cascaded_weak_classifiers{5};
                    result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);
                    if(max(result(:))<=thresholds{5})
                        fprintf('Image no. %d rejected by classifier 5\n',k);
                        result = 0;
                    end
                else
                    fprintf('Image no. %d rejected by classifier 4\n',k);
                    result = 0;
                end
            else
                fprintf('Image no. %d rejected by classifier 3\n',k);
                result = 0;
            end
        else
            fprintf('Image no. %d rejected by classifier 2\n',k);
            result = 0;
        end
    else
        fprintf('Image no. %d rejected by classifier 1\n',k);
        result = 0;
    end
  
  [M,lindex] = max(result(:));
  total = total+1;
  
  if M<=0
      false_negatives = false_negatives+1;
      if ((mod(k,random_number(47,49)) ==0) && face_moved<300 && moved<10)
          movefile(fullFileName,'D:\Uni\CSE468\Project\data\face');
          moved=moved+1;
      end
  end
  if(moved>9)
      break;
  end
end
face_moved = face_moved+moved;
save('fm','face_moved');
fprintf('False negatives: %d Total: %d\n',false_negatives,total);
fprintf('%d faces moved\n',moved);

error = 100*false_negatives/total;
load ext

if(error>5)
    if((error+0.5<=e)||(error-0.5>=e))
        e = error;
        save('ext','e');
        train;
    end
end