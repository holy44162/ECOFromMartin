clear;
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);

% Add paths
setup_paths();

% Load video information
% video_path = 'sequences/Crossing';
% video_path = 'd:/data_seq/sequences/dog1';

% video_path = 'd:/data_seq/sequences/windingRopeTrain';
% video_path = 'd:/data_seq/sequences/windingRopeCV';
% video_path = 'd:/data_seq/sequences/windingRopeTest';
% video_path = 'd:/data_seq/sequences/realWindingRopeTrain';
% video_path = 'd:/data_seq/sequences/realWindingRopeCV';
% video_path = 'd:/data_seq/sequences/realWindingRopeTest';
% video_path = 'd:/data_seq/sequences/realWindingRopesCompact';
video_path = 'd:/data/windingRope/20180801/dayLeft';

[seq, ground_truth] = load_video_info(video_path);

% Run ECO
results = saveTrackedTargetsParas(seq);