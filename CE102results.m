% FFT measurement results along with CE102 limit on a 
% logarithmic frequency scale
function CE102results(fVec, SignalMagnitudeCorrection, numberOfFiles, ambient, saveFile, signalPeak, signalPeakFreq, fileTitle, filePath)

% Limit line according to CE102 requirement
limit = 'CE102limit.csv';
N = csvread(limit);
limitx = N(3:5, 1);
limity = N(3:5, 2);

% Requirement states that during calibration, the given signal 
% values needs to be at least 6dB below the limit. Makes data 
% analysis easier at first glance.
limitcalx = limitx;
limitcaly = limity.-6;

% Frequency limits of the standard, 10kHz - 30MHz
f_high = 30*10^6;
f_low = 1*10^4;

figure(numberOfFiles);
semilogx(fVec, ambient, "color", 'm',...
       fVec, SignalMagnitudeCorrection,"color", 'b',...
       limitx, limity, "color", 'r', ...
       limitcalx, limitcaly, "color", 'g',...
       signalPeakFreq , signalPeak,"color",'r',"marker",'o');
       
% Show result from 10kHz to 30MHz and 0 to 60mV
axis([f_low, f_high, -50, 100]);
xlabel('Frequency (Hz)');
ylabel('Amplitude (dBuV)');
legend('Ambient' , 'Signal', 'Limit', '-6dB', 'Max Peak', 'Location','southeast');
grid on;

% Show maximum amplitude and its frequency on the plot
signalPeakFreqMHz = signalPeakFreq/10^6;
signalPeakString = num2str(signalPeak);
signalPeakFreqString = num2str(signalPeakFreqMHz);
peakMax = strcat("Max Peak:\n", signalPeakString, " dBuV\n", signalPeakFreqString, " MHz");
dim = [.15 0.15 0.15 0.15];
annotation("textbox", dim, "backgroundcolor", 'w', 'edgecolor', 'w', 'linewidth', 4, "String", peakMax);

% Titles for the plot, following the order of the files in 'data'
CE102titleNames(numberOfFiles);

% Save plots as jpg images with specified filename: Title, date
% and which n-th file
if (saveFile == 1)
  fileNumber = num2str(numberOfFiles);
  fileDate = datestr(now(), 29);
  fileName = strcat(fileTitle, fileDate, "_", fileNumber);
  saveas(numberOfFiles, fullfile(filePath, fileName), 'jpg');
end
end
