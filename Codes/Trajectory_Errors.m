tic;
data = load('dataset_UAV.mat');
c = 3e8;
lambda = c / data.f0;

% main trajectory
Sx_orig = data.Sx;
Sy_orig = data.Sy;
Sz_orig = data.Sz;

std_devs = [lambda/10, lambda/6, lambda/4, lambda/2];

for k = 1:length(std_devs)
    
    Sx_noisy = Sx_orig + std_devs(k) * randn(size(Sx_orig));
    Sy_noisy = Sy_orig + std_devs(k) * randn(size(Sy_orig));
    Sz_noisy = Sz_orig + std_devs(k) * randn(size(Sz_orig));
    
    
    TDBP_image_noisy = zeros(size(TDBP_image));
    for i = 1:length(Sx_noisy)
        R = sqrt((X - Sx_noisy(i)).^2 + (Y - Sy_noisy(i)).^2 + (Z - Sz_noisy(i)).^2);
        %fprintf('Processing trajectory sample %d of %d...\n', i, length(data.Sx));
        interpolated_data = interp1(data.r_ax, data.RCData(:, i), R, 'linear', 0);
        
        phase_term = exp(1j * 4 * pi / lambda * R);
        focused_data = interpolated_data .* phase_term;        
        TDBP_image_noisy = TDBP_image_noisy + focused_data;
    end
    
    TDBP_image_noisy_magnitude = abs(TDBP_image_noisy);
    std_labels = {"\lambda/10", "\lambda/6", "\lambda/4", "\lambda/2"}; % Labels for title

    figure;
    imagesc(x, y, TDBP_image_noisy_magnitude);
    colorbar;
    axis equal;
    title(sprintf('SAR Image with Trajectory Noise (%s)', std_labels{k}));
    xlabel('X (meters)');
    ylabel('Y (meters)');
end

elapsed_time = toc;
fprintf('Execution Time: %.2f seconds (%.2f minutes)\n', elapsed_time, elapsed_time / 60);