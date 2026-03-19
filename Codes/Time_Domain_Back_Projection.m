tic;
data = load('dataset_UAV.mat');
c = 3e8;
lambda = c / data.f0;

% Define grid for TDBP
x = -100:0.2:100; % grid spacing = 0.2 is the best value for best resolution of image
y = 80:0.2:200;
[X, Y] = meshgrid(x, y);
Z = zeros(size(X));
TDBP_image = zeros(size(X));

% Loop through trajectory samples
for i = 1:length(data.Sx)
    R = sqrt((X - data.Sx(i)).^2 + (Y - data.Sy(i)).^2 + (Z - data.Sz(i)).^2);
    %fprintf('Processing trajectory sample %d of %d...\n', i, length(data.Sx));

    % Evaluate range-compressed data according to the giudance
    interpolated_data = interp1(data.r_ax, data.RCData(:, i), R, 'linear', 0);
    
    phase_term = exp(1j*4*pi/lambda*R);
    focused_data = interpolated_data .* phase_term;
    TDBP_image = TDBP_image + focused_data;
end

TDBP_image_magnitude = abs(TDBP_image);

figure;
imagesc(x, y, TDBP_image_magnitude);
colorbar;
axis equal;
title('SAR Image (TDBP)');
xlabel('X (meters)');
ylabel('Y (meters)');
caxis([0, max(TDBP_image_magnitude(:)) * 0.1]);

elapsed_time = toc;
fprintf('Execution Time: %.2f seconds (%.2f minutes)\n', elapsed_time, elapsed_time / 60);
