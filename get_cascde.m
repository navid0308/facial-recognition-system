load cascades\1boosted
load cascades\1training
cascaded_classifiers{1}=boosted_classifier;
cascaded_weak_classifiers{1}=weak_classifiers;
load cascades\2boosted
load cascades\2training
cascaded_classifiers{2}=boosted_classifier;
cascaded_weak_classifiers{2}=weak_classifiers;
load cascades\3boosted
load cascades\3training
cascaded_classifiers{3}=boosted_classifier;
cascaded_weak_classifiers{3}=weak_classifiers;
load cascades\4boosted
load cascades\4training
cascaded_classifiers{4}=boosted_classifier;
cascaded_weak_classifiers{4}=weak_classifiers;
load cascades\5boosted
load cascades\5training
cascaded_classifiers{5}=boosted_classifier;
cascaded_weak_classifiers{5}=weak_classifiers;
save('cascade','cascaded_classifiers','cascaded_weak_classifiers');