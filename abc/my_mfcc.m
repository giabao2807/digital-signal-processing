function v = my_mfcc(x,fs,num_filters,varargin)

% This function computes the Mel Frequency Cepstral Coefficients (MFCC) for
% a given input Sound Track

if varargin=="image"
    figure;
    plot((0:length(x)-1)*1/fs,x);
    title("Input Sound Track (Time Domain)");
    xlabel("Time \Rightarrow");
    ylabel("Amplitude");
    
    figure;
    plot(linspace(-fs/2,fs/2,length(x)),fftshift(abs(fft(x))));
    title("Spectrum of Input Sound Track");
    xlabel("Frequency \Rightarrrow");
    ylabel("Amplitude");
end

Nfft = 0.03*fs; % Frame Size
noverlap = 0.02*fs; % Overlap Between 


% Now Compute the Spectrogram for the Signal

s = spectrogram(x,hamming(Nfft),noverlap,Nfft);

if varargin=="image"
    figure;
    spectrogram(x,hanning(Nfft),noverlap,Nfft);
    title("Normal Spectrogram using Short Time Fourier Transform");
    xlabel("Time \Rightarrow");
    ylabel("Frequency");
    
end

% Power Spectrum Conversion

s_power = (1/Nfft)*abs(s).^2;

% Create the Mel-Filter Bank 

melfb = make_melFB(num_filters,fs,Nfft);

if varargin == "image"
    
    figure;
    plot(linspace(0, (fs/2), Nfft/2+1), melfb');
    xlabel("Frequency \Rightarrow");
    ylabel("Gain");
    title("Mel Filter Bank");   
end

% Apply Mel Filters to Power-Spectrum

melScaled_s_power = melfb*s_power;


% 
% % Summing up the Energies in Each Filter
% 
% melSpectrum_coeff = sum(melScaled_s_power,1);

% Taking the Log

melSpectrum_coeff_log = log10(melScaled_s_power);


% Taking the Discrete Cosine Transform

mfcc_all = dct(melSpectrum_coeff_log);

mfcc = mfcc_all(2:end,1:end);



%
v = zeros(1,num_filters-1);
    for i=1:num_filters-1
        v(i)=mean(mfcc(i,:));
    end
end



% % Extracting the Relevant MFCC's
% 
% mfcc = mfcc_all(1,2:21);
% 
% % Calculating delta and delta-delta
% 
% delta_all = make_delta(mfcc_all);
% 
% delta  = delta_all(1,2:13);
% 
% 
% delta_delta_all = make_delta(delta_all);
% 
% delta_delta = delta_delta_all(2:13);


