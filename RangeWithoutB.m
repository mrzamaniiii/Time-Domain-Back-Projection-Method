clc;
clear;
data = load('dataset_UAV.mat');
RCData = double(data.RCData);
r_ax = data.r_ax;
c = 3e8;

delta_r = r_ax(2) - r_ax(1);
%fprintf('Range bin spacing: %.2e meters\n', delta_r);

f_s = c / (2 * delta_r); % Sampling frequency derived from range bin spacing
%fprintf('Sampling frequency: %.2f Hz\n', f_s);

N = size(RCData, 1); % Number of samples
num_pulses = size(RCData, 2);

freq_data_pulses = zeros(N, num_pulses);

for i = 1:num_pulses
    freq_data_pulses(:, i) = fft(RCData(:, i), N);
end

avg_freq_data = mean(abs(freq_data_pulses), 2);

freq_axis = linspace(0, f_s / 2, N / 2);  % Positive frequency axis
avg_freq_data = avg_freq_data(1:N/2);

total_energy = sum(avg_freq_data);
cumulative_energy = cumsum(avg_freq_data) / total_energy;

% Determine significant frequency range (5% to 95% of cumulative energy)
low_index = find(cumulative_energy > 0.05, 1, 'first');
high_index = find(cumulative_energy > 0.95, 1, 'first');

% Estimate bandwidth
if ~isempty(low_index) && ~isempty(high_index)
    bandwidth = freq_axis(high_index) - freq_axis(low_index);
    fprintf('The computed bandwidth is: %.2f Hz\n', bandwidth);
    
    range_resolution_estimate = c / (2 * bandwidth);
    fprintf('Range Resolution Estimate: %.2f meters\n', range_resolution_estimate);
else
    fprintf('No significant bandwidth detected. Check your data or threshold.\n');
end

figure;
plot(freq_axis, avg_freq_data, 'LineWidth', 1.5);
hold on;
yline(avg_freq_data(low_index), 'r--', 'Low Threshold');
yline(avg_freq_data(high_index), 'g--', 'High Threshold');
hold off;
title('Frequency Domain Representation');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
legend('Frequency Spectrum', 'Low Threshold', 'High Threshold');
