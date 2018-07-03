
% This demo script runs the ECO tracker with hand-crafted features on the
% included "Crossing" video.
clear;
% Add paths
setup_paths();

% Load video information
% video_path = 'sequences/Crossing';
% video_path = 'd:/data_seq/sequences/dog1';

% video_path = 'd:/data_seq/sequences/windingRopeTrain';
% video_path = 'd:/data_seq/sequences/windingRopeCV';
video_path = 'd:/data_seq/sequences/windingRopeTest';

[seq, ground_truth] = load_video_info(video_path);

% Run ECO
results = testing_ECO_HC_ML(seq);