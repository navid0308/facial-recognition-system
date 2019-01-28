function train_face(threshold,error_threshold,bootstrap)
load training;
load boosted;
load fm;
AVG = NaN;

moved = 0;

myFolder = 'D:\Uni\CSE468\Project\data\training_faces';
ext = '.bmp';

filePattern = fullfile(myFolder, strcat('*',ext));
Files = dir(filePattern);
Files = Files(randperm(length(Files))); %randomize
counter = 0;
total = 0;

for k = 1:length(Files)
  baseFileName = Files(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  img = read_gray(fullFileName);
  img = img(30:89,26:75);
  result = boosted_multiscale_search(img, 1, boosted_classifier, weak_classifiers, [60 50]);%>8;
  [M,lindex] = max(result(:));
  if(isnan(AVG(end)))
      AVG(end)=M;
  else
      AVG(end+1)=M;
  end
  total = total+1;
  
  if M<threshold
      counter = counter+1;
      if ((mod(k,random_number(147,149)) ==0) && face_moved<250 && moved<5 && bootstrap)
          movefile(fullFileName,'D:\Uni\CSE468\Project\data\face');
          moved=moved+1;
      end
  end
  if(moved>4)
      break;
  end
end

face_moved = face_moved+moved;
save('fm','face_moved');

error = double(100*counter/total);
fprintf('TRAINING FACE, ACCURACY: %f\n%d face(s) moved\n',100-error,moved);

fprintf('Tested on %d faces\n',total);
filePattern = fullfile('D:\Uni\CSE468\Project\data\face', strcat('*',ext));
Files = dir(filePattern);
fprintf('Training set: %d faces\n',length(Files));
%fprintf('DEBUGGING: Max %d Min %d Mean %f\n',max(AVG),min(AVG),mean(AVG));

if(bootstrap)
    threshold = mean(AVG)/1.1;
end

learn;
load etf;

if(error>error_threshold)
    if((error+0.5<=e)||(error-0.5>=e))
        e=error;
        save('etf','e');
        train_face(threshold,error_threshold,bootstrap);
    end
end
save('threshold','threshold');