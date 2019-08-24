% Purpose:    Data analysis with Fast Fourier Tranform (FFT) for 
%             EMC pre-compliance test based on MIL-STD-461G CE102
% Equipment:  Oscilloscope Rigol DS4024
%             LISN 50uH
% Version:    1.0, March 2019
% Author:     Siiri Talvistu
clear all
close all

% Sampling frequency of oscilloscope
% must be concurrent with actual measurement
Fs = 50*10^6; 

%% INPUT: 
% Measured data files
data =['';];

% FFT as many times as there are files in 'data'
A = rows(data);

%% Saving plots to a directory
% TO SAVE '1' or NOT TO SAVE '0'. That is the question.
saveFile = 0;

% SAVE AS. The saved title includes also a date and iteration
% sequence number
fileTitle = 'CE102_';

% SAVE LOCATION. Needs to be an already existing folder
filePath = '';

for numberOfFiles = 1:A
% Fast Fourier Transform of measured data
[fVec, SignalMagnitudeCorrection, signalPeak, signalPeakFreq, signalPeakIndex] = CE102FFT(Fs, numberOfFiles, data);

% The first row on data is considered as ambient measurement 
% and is plotted on every graph
if (numberOfFiles == 1)
  ambient = SignalMagnitudeCorrection; 
endif

% Plot figures of all given 'data' files in logarithmic scale
CE102results(fVec, SignalMagnitudeCorrection, numberOfFiles, ambient, saveFile, signalPeak, signalPeakFreq, fileTitle, filePath);
end