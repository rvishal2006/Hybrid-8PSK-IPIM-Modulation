%% Transmitter Side: 8-PSK + 4-Level Delay Modulation over UDP
clear; clc; close all;

% Create UDP object
txPort = 30000;    % Port to send from
rxPort = 30001;    % Port to send to (receiver's listening port)
uTx = udpport("datagram", "IPV4");

% User Inputs
msgA = input('Enter Message A (for 8-PSK): ', 's');
msgB = input('Enter Message B (for delay encoding): ', 's');

% Convert to bitstreams
bitstreamA = reshape(dec2bin(msgA,8).'-'0', 1, []);
bitstreamB = reshape(dec2bin(msgB,8).'-'0', 1, []);

% Trim for fitting modulation requirements
bitstreamA = bitstreamA(1:3*floor(length(bitstreamA)/3));  % 3 bits for 8-PSK
bitstreamB = bitstreamB(1:2*floor(length(bitstreamB)/2));  % 2 bits for delay

% Combine bitstreams into one
combined_bitstream = [bitstreamA, bitstreamB];

% Calculate the length of the combined bitstream (actual data length)
data_length = length(combined_bitstream);

% Encode the length as an 8-bit field
length_field = de2bi(data_length, 8, 'left-msb');

% Modulation Parameters for 8-PSK
M = 8; % 8-PSK
phase_angles = (0:M-1)*2*pi/M;
psk_map = exp(1j * phase_angles);

% PSK can carry 3 bits per symbol, so we encode the length field and then bitstreamA
% Prepend length field to the 8-PSK stream (bitstreamA)
psk_bitstream = [length_field, bitstreamA];

% Pad psk_bitstream to ensure its length is divisible by 3
padding_bits = mod(3 - mod(length(psk_bitstream), 3), 3);
if padding_bits > 0
    psk_bitstream = [psk_bitstream, zeros(1, padding_bits)];
end

% 8-PSK Encoding for length field and message A
symbolsA = reshape(psk_bitstream, 3, []).'; % Reshape into groups of 3 bits
symbol_indices = bi2de(symbolsA, 'left-msb') + 1;
modulated_symbols = psk_map(symbol_indices);

% Delay Encoding (IPIM) for message B
delay_symbols = reshape(bitstreamB, 2, []).';
delay_indices = bi2de(delay_symbols, 'left-msb');
delay_durations = [0, 0.0005, 0.001, 0.0015]; % seconds

% Time-domain waveform generation
fs = 1e4;                    % Sampling frequency
samples_per_symbol = fs / 1000;  % 10 samples per symbol at 1000 symbols/sec rate
carrier_freq = 2000;          % Carrier Frequency

tx_signal = [];
t_vec = [];
t = 0;

% Generate the signal with PSK modulation and inter-pulse intervals
for i = 1:length(modulated_symbols)

    % Create time vector for this symbol
    t_sym = (0:samples_per_symbol-1)/fs;

    % Generate carrier modulated with PSK symbol
    carrier = real(modulated_symbols(i) * exp(1j*2*pi*carrier_freq*t_sym));

    % Add to output signal
    tx_signal = [tx_signal, carrier];
    t_vec = [t_vec, t + t_sym];

    % Advance time by symbol duration
    t = t + samples_per_symbol/fs;

    % Add delay if we have delay symbols available
    if i <= length(delay_indices)

        % Get the delay duration for this symbol
        d = delay_durations(delay_indices(i)+1);

        % Generate silent gap (zeros) for the delay duration
        gap = zeros(1, round(fs*d));

        % Add gap to output signal
        tx_signal = [tx_signal, gap];
        t_vec = [t_vec, t + (0:length(gap)-1)/fs];

        % Advance time by delay duration
        t = t + d;
    end
end

% Plot transmitted signal
figure;
plot(t_vec, tx_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Transmitted 8-PSK + Delay Encoded Signal');

% Add markers for signal segments and gaps
hold on;
y_lim = max(abs(tx_signal)) * 1.1;
t_current = 0;

for i = 1:length(modulated_symbols)

    % Mark PSK symbol
    plot([t_current, t_current], [-y_lim, y_lim], 'g--');
    t_current = t_current + samples_per_symbol/fs;

    % Mark end of PSK symbol
    plot([t_current, t_current], [-y_lim, y_lim], 'r--');

    % If there's a delay for this symbol, mark it
    if i <= length(delay_indices)

        d = delay_durations(delay_indices(i)+1);
        t_current = t_current + d;

        plot([t_current, t_current], [-y_lim, y_lim], 'b--');
    end
end

hold off;

% Display information about the data being sent
disp(['Message A (8-PSK encoded): ', msgA]);
disp(['Message B (delay encoded): ', msgB]);
disp(['PSK bitstream length: ', num2str(length(psk_bitstream)), ' bits']);
disp(['Delay bitstream length: ', num2str(length(bitstreamB)), ' bits']);
disp(['Combined data length: ', num2str(data_length), ' bits']);
disp(['Number of PSK symbols: ', num2str(length(modulated_symbols))]);
disp(['Number of delay symbols: ', num2str(length(delay_indices))]);

% Send via UDP
disp('Sending waveform over UDP...');

% Convert the signal to single precision to reduce UDP packet size
tx_signal_single = single(tx_signal);

% Ensure tx_signal length is a multiple of 4 for proper single conversion (4 bytes per single)
padding = mod(4 - mod(length(tx_signal_single), 4), 4);

if padding > 0
    tx_signal_single = [tx_signal_single, zeros(1, padding, 'single')];
end

% Write as single precision
write(uTx, tx_signal_single, "127.0.0.1", rxPort);

disp('Transmission complete.');
