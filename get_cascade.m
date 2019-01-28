function [cascaded_classifiers,cascaded_weak_classifiers,thresholds] = get_cascade
load cascades\1cascade
cascaded_classifiers{1}=boosted_classifier;
cascaded_weak_classifiers{1}=weak_classifiers;
thresholds{1}=threshold;
load cascades\2cascade
cascaded_classifiers{2}=boosted_classifier;
cascaded_weak_classifiers{2}=weak_classifiers;
thresholds{2}=threshold;
load cascades\3cascade
cascaded_classifiers{3}=boosted_classifier;
cascaded_weak_classifiers{3}=weak_classifiers;
thresholds{3}=threshold;
load cascades\4cascade
cascaded_classifiers{4}=boosted_classifier;
cascaded_weak_classifiers{4}=weak_classifiers;
thresholds{4}=threshold;
load cascades\5cascade
cascaded_classifiers{5}=boosted_classifier;
cascaded_weak_classifiers{5}=weak_classifiers;
thresholds{5}=threshold;