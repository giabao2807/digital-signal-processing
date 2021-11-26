%%% plot magnitue spectrum of signal using FFT
% generate signal
Fs=10000;  % in Hz
F1=1000;    % in Hz
F2=2000;    % in Hz
F3=3000;    % in Hz
duration=2; % in seconds
nSamples=100;% number of signal samples for plotting

t=0:1/Fs:duration;
y=3*sin(2*pi*F1*t)+2*sin(2*pi*F2*t)+1*sin(2*pi*F3*t); % signal of 2 frequencies
sound(y,Fs);

figure(1)

% normalize signal magnitude
max_value=max(abs(y));
y=y/max_value;

% create time base
t=1/Fs:1/Fs:(length(y)/Fs);
subplot(2,1,1);plot(t(1:nSamples),y(1:nSamples),'k','LineWidth',1);
title('Signal waveform');
xlabel('Time (seconds)');
ylabel('Normalized magnitude');

% plot linear magnitue spectrum of signal
N_FFT = 1024; % number of frequency samples
dfty=abs(fft(y, N_FFT)); % get samples of magnitude spectrum
k=1:N_FFT; % k axis
w=k*Fs/N_FFT; % frequency axis
subplot(2,1,2);plot(w(1:N_FFT/2),dfty(1:N_FFT/2),'k','LineWidth',1);
title('Linear Magnitude Spectrum');
xlabel('Frequency (Hz)')
ylabel('Magnitude');


