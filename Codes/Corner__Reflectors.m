load('dataset_UAV.mat');
lambda = 3e8 / f0;
c = 3e8;
corner_x = -6;
corner_y = 101;
patch_size = 5;
L_s = 4; %% Example synthetic aperture length

x_patch = linspace(corner_x - patch_size/2, corner_x + patch_size/2, 200);
y_patch = linspace(corner_y - patch_size/2, corner_y + patch_size/2, 200);
[X_patch, Y_patch] = meshgrid(x_patch, y_patch);
Z_patch = zeros(size(X_patch));

patch_image = zeros(size(X_patch));
for i = 1:length(Sx)
    R = sqrt((X_patch - Sx(i)).^2 + (Y_patch - Sy(i)).^2 + (Z_patch - Sz(i)).^2);
    RC_interpolated = interp1(r_ax, RCData(:, i), R, 'linear', 0);
    patch_image = patch_image + RC_interpolated .* exp(1j * 4 * pi / lambda * R);
end

patch_image_magnitude = abs(patch_image);

% Plot the SAR patch image
figure;
imagesc(x_patch, y_patch, patch_image_magnitude);
colorbar;
title('Focused SAR Image (Patch)');
xlabel('X Coordinate (m)');
ylabel('Y Coordinate (m)');

r_P = mean(mean(sqrt((X_patch - mean(Sx)).^2 + (Y_patch - mean(Sy)).^2)));

% Azimuth Resolution
azimuth_resolution = r_P * lambda / (2 * L_s);
fprintf('Azimuth Resolution: %.4f meters\n', azimuth_resolution);

fft_image = fft2(patch_image_magnitude);
fft_image_shifted = fftshift(fft_image); % Shift zero frequency to center
fft_magnitude = abs(fft_image_shifted);

[rows, cols] = size(fft_image);
%dx = x_patch(2) - x_patch(1); % Spatial sampling interval in X
dy = y_patch(2) - y_patch(1); % Spatial sampling interval in Y
%freq_x = linspace(-1/(2*dx), 1/(2*dx), cols);
freq_y = linspace(-1/(2*dy), 1/(2*dy), rows);

threshold = max(fft_magnitude(:)) * 0.01; % Threshold for significant energy
[energy_rows, energy_cols] = find(fft_magnitude > threshold);

if ~isempty(energy_rows) && ~isempty(energy_cols)
    %max_freq_x = max(abs(freq_x(energy_cols)));
    max_freq_y = max(abs(freq_y(energy_rows)));

    % Calculate resolution
    %resolution_x = 1 / max_freq_x; % Resolution in X direction (meters)
    resolution_y = 1 / max_freq_y; % Resolution in Y direction (meters)

    fprintf('Resolution in Y direction (FFT-based): %.4f meters\n', resolution_y);
else
    fprintf('No significant spatial frequencies detected. Check your data.\n');
end