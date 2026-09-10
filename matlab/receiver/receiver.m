%% Receiver Side: 8-PSK + Delay-based IPIM over UDP
clear; clc; close all;

% Create UDP receiver
rxPort = 30001;   % Port number
uRx = udpport("datagram", "IPV4", "LocalPort", rxPort);

disp('Receiver ready, waiting for data...');

% Wait until at least one datagram is available
while uRx.NumDatagramsAvailable == 0
    pause(0.1);  % Avoid busy waiting
end

% Read the single datagram (assuming entire waveform sent as one)
% Read received datagram
disp('Reading data...');
try
    % Read the first available datagram
    d = read(uRx, 1, "uint8");  % Read 1 datagram as uint8

    % Typecast from uint8 to single (4 bytes per single)
    if mod(length(d.Data), 4) ~= 0
        error('Data length not divisible by 4, cannot typecast to single');
    end

    rx_signal = double(typecast(d.Data, 'single'));  % Convert to double for processing

    disp('Successfully read and converted data from uint8 -> single -> double');

catch ME
    disp('Failed to read UDP data:');
    disp(ME.message);
    return;
end

disp('Data received!');
disp(['Data type: ', class(rx_signal)]);
disp(['Data size: ', num2str(size(rx_signal))]);

% Plot received signal
figure;
plot(rx_signal);
xlabel('Samples');
ylabel('Amplitude');
title('Received Signal');

%% Demodulation Parameters
M = 8;                      % 8-PSK
fs = 1e4;                   % Sampling Frequency
symbol_rate = 1000;         % Symbol rate
samples_per_symbol = fs / symbol_rate;
carrier_freq = 2000;        % Carrier frequency
threshold = 0.002;          % Silence threshold

%% Signal Segmentation and Gap Detection
signal_segments = [];
gaps = [];
in_gap = false;
gap_start = 0;
segment_start = 1;

for i = 1:length(rx_signal)

    if abs(rx_signal(i)) < threshold

        if ~in_gap
            in_gap = true;
            gap_start = i;

            if i > 1
                signal_segments = [signal_segments; segment_start, i-1];
            end
        end

    else

        if in_gap
            in_gap = false;
            gaps = [gaps; gap_start, i-1];
            segment_start = i;
        end

    end
end

if ~in_gap && segment_start <= length(rx_signal)
    signal_segments = [signal_segments; segment_start, length(rx_signal)];
end

disp(['Detected ', num2str(size(signal_segments, 1)), ' signal segments']);
disp(['Detected ', num2str(size(gaps, 1)), ' gaps']);

% Calculate gap durations
gap_durations = [];

for i = 1:size(gaps, 1)
    duration = (gaps(i, 2) - gaps(i, 1) + 1) / fs;
    gap_durations = [gap_durations; duration];
end

%% Decode 8-PSK symbols
phase_angles = (0:M-1)*2*pi/M;
psk_map = exp(1j * phase_angles);

demodulated_bits_8psk = [];
demodulated_bits_delay = [];

for i = 1:size(signal_segments, 1)

    segment = rx_signal(signal_segments(i, 1):signal_segments(i, 2));

    if length(segment) >= 0.3 * samples_per_symbol

        t_sym = (0:length(segment)-1)/fs;

        baseband = segment .* exp(-1j*2*pi*carrier_freq*t_sym);

        phase = angle(mean(baseband));

        if phase < 0
            phase = phase + 2*pi;
        end

        [~, idx] = min(abs(angle(psk_map) - phase));

        symbol_idx = idx - 1;

        bits = de2bi(symbol_idx, 3, 'left-msb');

        demodulated_bits_8psk = [demodulated_bits_8psk; bits];

    end

    if i < size(signal_segments, 1)

        delay_time = gap_durations(i);

        delay_levels = [0, 0.0005, 0.001, 0.0015];

        [~, delay_idx] = min(abs(delay_time - delay_levels));

        delay_idx = delay_idx - 1;

        delay_bits = de2bi(delay_idx, 2, 'left-msb');

        demodulated_bits_delay = [demodulated_bits_delay; delay_bits];

    end

end

disp(['Demodulated ', num2str(size(demodulated_bits_8psk, 1)), ' PSK symbols']);
disp(['Demodulated ', num2str(size(demodulated_bits_delay, 1)), ' delay symbols']);

%% Reconstruct Messages
demodulated_bits_8psk = reshape(demodulated_bits_8psk', 1, []);
demodulated_bits_delay = reshape(demodulated_bits_delay', 1, []);

if length(demodulated_bits_8psk) >= 8

    length_field = demodulated_bits_8psk(1:8);

    data_length = bi2de(length_field, 'left-msb');

    disp(['Decoded data length: ', num2str(data_length), ' bits']);

    bits_msgA = demodulated_bits_8psk(9:end);
    bits_msgB = demodulated_bits_delay;

    % Pad to 8-bit boundaries
    padA = mod(8 - mod(length(bits_msgA), 8), 8);

    if padA < 8
        bits_msgA = [bits_msgA, zeros(1, padA)];
    end

    padB = mod(8 - mod(length(bits_msgB), 8), 8);

    if padB < 8
        bits_msgB = [bits_msgB, zeros(1, padB)];
    end

    if length(bits_msgA) >= 8

        ascii_msgA = bi2de(reshape(bits_msgA, 8, []).', 'left-msb');

        msgA = char(ascii_msgA);

        disp('Decoded Message A (from 8-PSK):');
        disp(msgA);

    else

        disp('Not enough bits for Message A');

    end

    if length(bits_msgB) >= 8

        ascii_msgB = bi2de(reshape(bits_msgB, 8, []).', 'left-msb');

        msgB = char(ascii_msgB);

        disp('Decoded Message B (from delay encoding):');
        disp(msgB);

    else

        disp('Not enough bits for Message B');

    end

else

    disp('Error: Not enough bits received for length field');

end

% Plot demodulated bits
figure;

subplot(2,1,1);

if ~isempty(demodulated_bits_8psk)

    stairs(demodulated_bits_8psk, 'LineWidth', 1.5);

    title('Demodulated 8-PSK Bits');

    grid on;

end

subplot(2,1,2);

if ~isempty(demodulated_bits_delay)

    stairs(demodulated_bits_delay, 'LineWidth', 1.5);

    title('Demodulated Delay Bits');

    grid on;

end
