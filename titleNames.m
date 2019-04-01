% Titles for the figures plotted in CE102results.m
% Case numeration follows the same sequence as the files in 'data' at CE102main.m

function titleNames(numberOfFiles)
switch (numberOfFiles)
 case 1
   title(' Motherboard, Shielded, Terminated LISN+');
 case 2
   title(' Motherboard, Shielded, Terminated LISN+, cleaned table');
 case 3
   title('Motherboard I2T5, Shielded, Terminated LISN+');
 case 4
   title('Open leads with power on');
 case 5
   title('LISN+, 525kHz, 3mV, Calibration');
 case 6
   title('LISN+, 787kHz, 3mV, Calibration');
endswitch
endfunction