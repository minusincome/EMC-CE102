% FFT calculation based on results from the oscilloscope
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

% RMS of peak value, Requirement in the MIL-STD
amplitude = amplitude/sqrt(2);

% Length of FFT to be same as Sampling frequency or higher. 
% With the equal value of measured points the results are most 
% accurate (tested with signal generator)
nfft = length(amplitude);

% Fast Fourier Transform with padding of zeros so that 
% length(Signal) is equal to nfft
Signal = fft(amplitude, nfft);

% Takes only one side
Signal = Signal(1:nfft/2 + 1);

% Take magnitude of FFT of Signal
SignalMagnitudeAbs = abs(Signal);

% Normalisation and taking into account the total power
SignalMagnitude = SignalMagnitudeAbs/nfft;

% Frequency Vector
fVec = (Fs/2)*linspace(0, 1, nfft/2 + 1);

% Correction factor that accounts for the 20dB attenuator and 
% voltage drops across the coupling capacitor in the LISN
CF = ((((1+(5.6*10^(-9)).*fVec.^2).^0.5)./(fVec.*7.48*10^(-5))));
CFt = CF.';
SignalMagnitudeCorrection = SignalMagnitude.*CFt;

% Conversion from V to dBuV
SignalMagnitudeCorrection = 20*log10(SignalMagnitudeCorrection.*10^6);

% Maximum peak value between 10kHz - 30MHz
fVecLength = columns(fVec);
f_low = 10*10^3;
step1 = fVec(1,2); %119.21Hz
stepLast = fVec(1, end); %62.5MHz
% percentage of 10kHz from 62.5MHz
fVecStart = f_low*100/stepLast; 
% Sequence number around 10kHz
fVec10 = fVecLength*fVecStart/100; 
% integer of sequence number at 10kHz
fVecStartIndex = floor(fVec10); 
% Sequence number around 31.25MHz
fVecEndIndex = floor(fVecLength/2); 
fVecEnd = fVec(1, fVecEndIndex); % 31.25 MHz
SMC = SignalMagnitudeCorrection(fVecStartIndex:fVecEndIndex, 1);
% Location of peak
[signalPeak signalPeakIndex] = max(SMC); 
signalPeakFreq = fVec(1, fVecStartIndex+signalPeakIndex); 
end
