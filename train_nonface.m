function train_nonface(error_threshold,bootstrap)
load training;
load boosted;
load nfm;
moved = 0;

myFolder = 'D:\Uni\CSE468\Project\data\training_nonfaces';
ext = '.JPG';

filePattern = fullfile(myFolder, strcat('*',ext));
Files = dir(filePattern);
Files = Files(randperm(length(Files))); %randomize
counter = 0;
total = 0;

for k = 1:length(Files)
  baseFileName = Files(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  [img,S] = patches(read_gray(fullFileName));
  bool = false;
  for i = 1:S-1
    result = boosted_multiscale_search(img(:,:,i), 1, boosted_classifier, weak_classifiers, [60 50]);
    [M,lindex] = max(result(:));
    total = total+1;
    if M>0
      counter = counter+1;
      bool = true;
    end
  end
  
  if(bool)
      if(mod(k,random_number(33,35)==0) && non_face_moved<45 && moved<1 && bootstrap)
        movefile(fullFileName,'D:\Uni\CSE468\Project\data\nonface');
        moved = moved+1;
      end
  end
  if(moved>0)
      break;
  end
end

non_face_moved = non_face_moved+moved;
save('nfm','non_face_moved');

error = double(100*counter/total);
fprintf('TRAINING NONFACE, ACCURACY: %f\n%d nonface(s) moved\n',100-error,moved);

fprintf('Tested on %d nonface patches\n',total);
filePattern = fullfile('D:\Uni\CSE468\Project\data\nonface', strcat('*',ext));
Files = dir(filePattern);
fprintf('Training set: %d nonfaces\n',length(Files));

learn;
load etnf;

if(error>error_threshold)
    if((error+0.5<=e)||(error-0.5>=e))
        e = error;
        save('etnf','e');
        train_nonface(error_threshold,bootstrap);
    end
end