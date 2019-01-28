function script(cno,number,threshold,error_threshold,bootstrap)

e = 100;
save('etf','e');
save('etnf','e');

faceFolder = 'D:\Uni\CSE468\Project\data\face';
faces = read_all_images(faceFolder,'.bmp','face');

nonfaceFolder = 'D:\Uni\CSE468\Project\data\nonface';
nonfaces = read_all_images(nonfaceFolder,'.JPG','nonface');

face_vertical = 60;
face_horizontal = 50;

[~,~,Flimit] = size(faces);
for i = 1:Flimit
    face_integrals(:,:,i) = integral_image(faces(:,:,i));
end

[~,~,NFlimit] = size(nonfaces);
for i = 1:NFlimit
    nonface_integrals(:,:,i) = integral_image(nonfaces(:,:,i));
end

if(bootstrap)
    weak_classifiers = cell(1, number);
    for x = 1:number
        weak_classifiers{x} = generate_classifier(face_vertical,face_horizontal);
    end
else
    load training;
end

fprintf('Classifier number: %d\n',cno);
if(bootstrap)
    fprintf('Training CLASSIFIER with BOOTSTRAPPING\n');
else
    fprintf('Training CLASSIFIER without BOOTSTRAPPING\n');
end
fprintf('WEAK CLASSIFIERS: %d\n',number);

example_number = size(faces, 3) + size(nonfaces, 3);
labels = zeros(example_number, 1);
labels (1:size(faces, 3)) = 1;
labels((size(faces, 3)+1):example_number) = -1;
examples = zeros(face_vertical, face_horizontal, example_number);
examples (:, :, 1:size(faces, 3)) = face_integrals;
examples(:, :, (size(faces, 3)+1):example_number) = nonface_integrals;
classifier_number = numel(weak_classifiers);
responses =  zeros(classifier_number, example_number);

for example = 1:example_number
    integral = examples(:, :, example);
    for feature = 1:classifier_number
        classifier = weak_classifiers {feature};
        responses(feature, example) = eval_weak_classifier(classifier, integral);
    end
end
[boosted_classifier] = AdaBoost(responses, labels, 10);

face_moved = 0;
save('fm','face_moved');

non_face_moved = 0;
save('nfm','non_face_moved');

save('training','responses', 'labels', 'classifier_number', 'example_number','weak_classifiers');
save('boosted','boosted_classifier');

train_face(threshold,error_threshold,bootstrap);
train_nonface(error_threshold,bootstrap);

%{
number = 30;
for i = 1:30
cascaded_classifiers = cell(1, number);
for x = 1:number
    cascaded_classifiers{x} = script;
end
save('cascade','cascaded_classifiers');
%}