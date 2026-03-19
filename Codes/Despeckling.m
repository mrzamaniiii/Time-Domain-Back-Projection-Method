original_image = TDBP_image_magnitude; % Use the magnitude image from previous steps

filter_sizes = [3, 5, 7];

% Loop through each filter size
for k = 1:length(filter_sizes)
    N = filter_sizes(k);
    filter = ones(N, N) / (N^2);
    despeckled_image = conv2(original_image, filter, 'same');
    
    figure;
    imagesc(despeckled_image);
    colorbar;
    axis equal;
    title(sprintf('Despeckled Image with %dx%d Filter', N, N));
    xlabel('X (meters)');
    ylabel('Y (meters)');
    
    caxis([0, max(despeckled_image(:)) * 0.5]);
end