function coord_tx = COORD_TX(Mtx,BS,lam,angBS)
%COORD_TXRX(Mtx,Nrx,BS,UE,lam,angBS,angUE) creates all the coordinates of
%the antennas at the BS and the UE.
%   Mtx: Nº of antennas at the BS
%   BS: 1st antenna location at the BS
%   lam: Carrier freqeucny in wavelenght (m)
%   angBS: Orientation angles of BS

dist_ant = 0.5;         % Antenna spacing at the BS and UE
theta_BS = angBS(1);    % Elevation angle of BS
phi_BS = angBS(2);      % Azimuth angle of BS

% BS COORDINATES acoording to eq(3.1)
coord_tx(1,:) = BS;
for r = 2:Mtx
    coord_tx(r,:) = coord_tx(r-1,:) + [sin(theta_BS)*sin(phi_BS), sin(theta_BS)*cos(phi_BS), cos(theta_BS)]*dist_ant*lam;
end

end

