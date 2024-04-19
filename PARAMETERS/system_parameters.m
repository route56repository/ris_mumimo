%% LOAD SIMULATION SYSTEM PARAMETERS
freq = 30e9;                        % Carrier freq
c = physconst('LightSpeed');        % Light speed
lam = c/freq;                       % Carrier freq in wavelength
Ptot = 10^(2.4)/1000;               % Total transmitted power (24 dBm) (ara ESTA A 250mW)
var2 = 10^(-9.4)/1000;              % Noise power (100 MHz)
BW = 100e6;                         % Channel bandwidth
v= 20 ;                             % Terminal velocity
dist_el = 0.5;                      % Distance between elements in wavelenghts
dist_ant = 0.5;                     % Distance between antennas in wavelenghts
Gt = 3;                             % BS antenna gain = 3dBi
Gr = Gt;                            % UE antenna gain = 3 dBi