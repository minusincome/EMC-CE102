% FFT measurement results along with CE102 limit on a logarithmic frequency scale

function CE102results(fVec, SignalMagnitudeCorrection, numberOfFiles, saveFile, signalPeak, signalPeakFreq, fileTitle, filePath)

% Limit line according to CE102 requirement
limit = 'CE102limit.csv';
N = csvread(limit);
limitx = N(3:5, 1);
limity = N(3:5, 2);

% Requirement states that during calibration, the given signal values needs to 
% be at least 6dB below the limit. Makes data analysis easier at first glance.
limitcalx = limitx;
limitcaly = limity./2;

% Frequency limits of the standard, 10kHz - 30MHz
f_high = 30*10^6;
f_low = 9*10^3;

figure(numberOfFiles);
loglog(fVec, SignalMagnitudeCorrection, "color", 'b',...
       limitx, limity, "color", 'r', ...
       limitcalx, limitcaly, "color", 'g',...
       signalPeakFreq , signalPeak, "color", 'r', "marker", 'o' );
       
% Show result from 10kHz to 30MHz and 0 to 60mV
axis([f_low, f_high, 0, 0.06]);
xlabel('Frequency (Hz)');
ylabel('Limit Level (V)');
legend('Data', 'Limit', '-6dB', 'Max Peak');
grid on;

% Show maximum amplitude and its frequency on the plot
signalPeakmV = signalPeak/10^-3;
signalPeakFreqMHz = signalPeakFreq/10^6;
signalPeakString = num2str(signalPeakmV);
signalPeakFreqString = num2str(signalPeakFreqMHz);
peakMax = strcat("Max Peak:\n", signalPeakString, "mV\n", signalPeakFreqString, "MHz");
dim = [.2 0.2 0.3 0.3];
annotation("textbox", dim, "edgecolor", 'w', "String", peakMax);

% Titles for the plot, following the order of the files in 'data'
titleNames(numberOfFiles);

% Save plots as jpg images
if (saveFile == 1)
  fileNumber = num2str(numberOfFiles);
  fileDate = datestr(now(), 29);
  fileName = strcat(fileTitle, fileDate, "_", fileNumber)
  saveas (numberOfFiles, fullfile(filePath, fileName), 'jpg');
endif
endfunction
