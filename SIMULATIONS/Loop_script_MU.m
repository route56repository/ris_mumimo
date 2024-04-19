% MAIN FILE TO BE EXECUTED
clear all
warning off;

% THEESE PAREMENTERS NEED TO BE SPECIFIED BEFORE 
% EXECUTING mapInitialization_MU
% Mtx: Number of antennas at the BS
% Nrx: Number of UEs
% RIS: Number of RIS
% NRIS: Number of RIS elements in total
% UE2: Position of the fixed UE2
% folderUE: Name of the folder where the results will be stored

Nrx = 2;
RIS = 1;
Mtx = 4;

UE2 = [20,35,1.5];
folderUE = '\NEAR';

% RIS = 2;
% Mtx=8;
NRIS = 800;
mapInitialization_MU;
% NRIS = 1200;
% mapInitialization_MU;
