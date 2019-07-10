
% The FFT calculation based on results obtained from the oscilloscope
% (Rigol DS4024). 

function [fVec, SignalMagnitudeCorrection, signalPeak, signalPeakFreq, signalPeakIndex] = CE102FFT(Fs, numberOfFiles, data)

% Analyse all the files in 'data'
M = csvread(data(numberOfFiles, 1:end));

% Amplitude [V] and Sequence
amplitude = M(3:end,2);
sequence = M(3:end,1);

%Set zero pad depth (Radix 2);
zeroPadDepth = 0;

% Remove DC component from the data
amplitude = amplitude - mean(amplitude);

% Length of FFT to be same as Sampling frequency or higher. With the equal value
% of measured points the results are most accurate (Tested with signal generator)
%nfft = 2^((nextpow2(length(amplitude)))+zeroPadDepth);
nfft = length(amplitude);

% Fast Fourier Transform with padding of zeros so that length(Signal) is
% equal to nfft
Signal = fft(amplitude, nfft);

% Takes only one side
Signal = Signal(1:nfft/2 + 1);

% Take magnitude of FFT of Signal
SignalMagnitudeAbs = abs(Signal);

% Normalisation and taking into account the total power (x2)
SignalMagnitude = 2*SignalMagnitudeAbs/nfft;

% Frequency Vector
fVec = (Fs/2)*linspace (0, 1, nfft/2 + 1);

% Correction factor that accounts for the 20dB attenuator and voltage drops 
% across the coupling capacitor (0.25uF, but our setup has 0.1uF) in the LISN
CF = (((1+(5.6*10^(-9)).*fVec.^2).^0.5)./(fVec.*7.48*10^(-5)));
CFt = CF.';
SignalMagnitudeCorrection = 20*(SignalMagnitude.*CFt);



% Maximum peak value between 10kHz - 30MHz
fVecLength = columns(fVec);
f_low = 10*10^3;
step1 = fVec(1,2); %119.21Hz
stepLast = fVec(1, end); %62.5MHz
fVecStart = f_low*100/stepLast; % percentage of 10kHz from 62.5MHz
fVec10 = fVecLength*fVecStart/100; % Sequence number around 10kHz
fVecStartIndex = floor(fVec10); % integer of sequence number at 10kHz
fVecEndIndex = floor(fVecLength/2); % Sequence number around 31.25MHz
fVecEnd = fVec(1, fVecEndIndex); % 31.25 MHz
SMC = SignalMagnitudeCorrection(fVecStartIndex:fVecEndIndex, 1);
[signalPeak signalPeakIndex] = max(SMC); % Location of peak
signalPeakFreq = fVec(1, fVecStartIndex+signalPeakIndex); 

endfunction































