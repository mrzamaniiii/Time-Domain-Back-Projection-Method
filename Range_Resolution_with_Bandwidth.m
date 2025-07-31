data = load('dataset_UAV.mat');
c = 3e8;
B = data.B;
range_resolution = c/(2*B);
fprintf('Range Resolution: %.2f meters\n', range_resolution)