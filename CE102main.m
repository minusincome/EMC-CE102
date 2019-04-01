%
% Purpose:    Data analysis with Fast Fourier Tranform (FFT) for EMC pre-compliance 
%             testing based on MIL-STD-461F CE102
%
% Equipment:  Oscilloscope Rigol DS4024
%             LISN 50uH
%
% Version:    1.0, March 2019
%
% Author:     Siiri Talvistu
%
% TODO: 
%    - Indicate, if the measured value goes above the limit line. 
%      Not relevant for calibration.

clear all
close all

% Sampling frequency of oscilloscope - must be concurrent with actual measurement
Fs = 125*10^6; 

%% INPUT: 
% Measured data files
data =['analyse\Motherboard\Newfile1.csv';
'analyse\Motherboard\Newfile2.csv';
'analyse\Motherboard\I2T5\Newfile1.csv';]

% FFT as many times as there are files in 'data'
A = rows(data);

%% Saving plots to a directory
%
% TO SAVE '1' or NOT TO SAVE '0'. That is the question.
saveFile = 1;

% SAVE AS. The saved title includes also a date and iteration sequence number
fileTitle = 'CE102_Motherboard_';
% SAVE LOCATION. Needs to be an already existing folder
filePath = 'Figures\Motherboard';

for numberOfFiles = 1:A
% Fast Fourier Transform of measured data
[fVec, SignalMagnitudeCorrection, signalPeak, signalPeakFreq, signalPeakIndex] = CE102FFT(Fs, numberOfFiles, data);

% Plot figures of all given 'data' files in logarithmic scale
CE102results(fVec, SignalMagnitudeCorrection, numberOfFiles, saveFile, signalPeak, signalPeakFreq, fileTitle, filePath);
endfor