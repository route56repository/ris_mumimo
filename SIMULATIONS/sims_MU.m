%% MATLAB SCRIPT THAT GENERATES SIMULATIONS FOR FIXED LOCATIONS AND 
% DIFFERENT VALUES OF NRIS

clear all; clc; warning off;
randn('seed',3);
rand('seed',3);
% f1 = figure('Name','Algoritme 2.2 (5-50)','NumberTitle','off');
% f2 = figure('Name','Algoritme 2.2 (55-100)','NumberTitle','off');
% f3 = figure('Name','Algoritme 2.2 (105-150)','NumberTitle','off');
% f4 = figure('Name','Algoritme 2.2 (155-200)','NumberTitle','off');

tic;
%% LOAD SYSTEM PARAMETERS
system_parameters;

%% TX-RX PARAMETERS
Mtx = 4;                            % Antennas at the BS
BS = [60 120 10];                   % Location 1st Antenna at the BS

Nrx = 2;                            % Antennas at the UE
UE = [5,20,1.5];                    % Location 1st antenna at the UE

% ORIENTATION ANGLES
theta_BS = pi/2;                    % BS Elevation (z-axis = pi/2)
phi_BS = pi/2;                      % BS Azimuth
angBS = [theta_BS,phi_BS];

theta_UE = pi/2;                    % UE Elevation
phi_UE = pi/2;                      % UE Azimuth
angUE = [theta_UE,phi_UE];


%% DIRECT CHANNEL - Hbu
% All possible antenna coordinates at the BS and UE
[coord_tx, coord_rx] = COORD_TXRX(Mtx,Nrx,BS,UE,lam,angBS,angUE);
coord_rx(2,:) = [20,35,2];
% Direct channel computation from Eq. 3.8
[Hbu_og,beta_bu] = NF_bu(coord_tx,coord_rx);
o1 = BS(1:2)-[20,40];
o2 = BS(1:2)-[-20,50];
cen_obs = [o1;o2];
len_ob = 10;
num_obs = 2;
coord_obs = COORDobstacle(num_obs,len_ob,[o1;o2],[0,0]);
obs_props = {coord_obs,len_ob,num_obs,cen_obs};
coord_obs = obs_props{1};
cen_obs = obs_props{4};
Hbu = channel_obs(coord_obs,cen_obs,coord_tx,coord_rx,Hbu_og);
Hbu_og = Hbu./beta_bu;
% Distance between 1st antenna BS and 1st antenna UE
dbu = norm(coord_rx(1,:)-coord_tx(1,:));

%% RIS PARAMETERS
RIS = 1;                                % Nº of RIS
loc = 1;                                % Location for Scenario 1
[RIS_i,ang_RIS] = RIS_parameters(RIS,loc,120);
Ny = 1;                                 % Nº of elements per column
if(RIS==2)
    Ny = [1,1];
end
Nz = 5;                                 % Nº of elements per row

% Plot top view of simulation setup
% figure;
% plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS_i,1);

for s = 1:(20/RIS)
    Nris(s) = Nz*sum(Ny);                            % Total number of RIS elements
    for r = 1:RIS
        % For each RIS
        % Calculate all element locations
        coord_ris = COORD_RIS(RIS_i{r},Nz,Ny(r),lam,ang_RIS{r});
        dbr = norm(coord_ris(1,:)-coord_tx(1,:)); % Minimum distance BS - RIS
        dru = norm(coord_rx(1,:)-coord_ris(1,:)); % Minimum distance RIS - UE

        % Calculate RIS-UE channel and BS-RIS channel
        if(s==20)
            disp('STOP')
        end
        [Hbr{r},Hru{r},s_path] = NF_Hc(Nz,Ny(r),coord_tx,coord_rx,coord_ris,ang_RIS{r});
        Hbr{r} = Hbr{r}*s_path;
    end
    matHbr = cell2mat(Hbr.')./beta_bu;
    matHru = cell2mat(Hru);
    random_phases = rand(Nris(s),1)*2*pi;    % Initial random RIS phases

    disp(['NRIS ', num2str(Nris(s))]);

    fases_no = diag(exp(1i*random_phases));
    % Optimize RIS phases to maximize alpha
    %[fases_rsm,it_rsm] = RIS_opt_RSM(random_phases, Hbu_og, matHbr, matHru,[f1,f2,f3,f4]);
    [fases_zf,it_zf] = RIS_opt_ZF(random_phases, Hbu_og, matHbr, matHru);
    % Compund channel
    Hc_zf = (matHru*fases_zf*matHbr); % RSM optimization
    Hc_no = (matHru*fases_no*matHbr);   % No optimization
    Hbu = Hbu_og*beta_bu;
    % Complete channel
    Ht_zf = Hbu + Hc_zf.*beta_bu;
    if(s==10)
        disp('')
    end
    % Alpha in RSM with ZF
    alpha_bu(s) = alpha_ZF(Hbu);         % Direct channel
    alpha(s) = alpha_ZF(Ht_zf);         % RIS-aided + It.Alg RSM

    % ABEP for RSM: Perfect estimation
    BER_bu(s) = BER_MQAM(alpha_ZF(Hbu),Ptot,var2,4);
    BER_t(s) = BER_MQAM(alpha_ZF(Ht_zf),Ptot,var2,4);

    % BER with error for RSM: Perfect estimation
    B_bu = Hbu'*inv(Hbu*Hbu');
    B = Ht_zf'*inv(Ht_zf*Ht_zf');
    T = Nris(s)+1;
    BERe_bu(s,:) = BER_4QAM_error(alpha_ZF(Hbu),Ptot,var2,B_bu,Nris(s),T,4);
    BERe_t(s,:) = BER_4QAM_error(alpha_ZF(Ht_zf),Ptot,var2,B,Nris(s),T,4);


    Ny = Ny+20;
    disp('');
end
toc;

%% PLOT FIGURES
plot_MU;
