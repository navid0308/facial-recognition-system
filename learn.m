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

load training;
  
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
boosted_classifier = AdaBoost(responses, labels, 15);
save('training','responses', 'labels', 'classifier_number', 'example_number','weak_classifiers');
save('boosted','boosted_classifier');