function varargout = mapCell_MU(coord_tx,UE2,RISs,Ny,x_i,y,ang_RIS,T,obs_props)
% mapINFO(BS,RISs,Ny,x_i,y,Mtx,Nrx,angBS,angUE,ang_RIS,mode) Computes
% all the neccesary information for an RSM transmission and returns the
% cell INFO
% INPUT PARAMETERS:
%   BS: 1st antenna at the BS
%   RISs: 1st element at the RIS(s)
%   Ny: Nº elements per column
%   x_i: x-coordinate of the 1st antenna at the UE
%   y: array with y-coordinates of the 1st antenna at the UE
%   Mtx: Nº of antennas at the BS
%   Nrx: Nº of antennas at the UE
%   angBS, angUE, ang_RIS: Orientation angles of BS, UE and RIS

% LOAD SYSTEM PARAMETERS
system_parameters;
randn('seed',3);
rand('seed',3);

% Initial UE1 position
UE1 = [x_i,0,1.5];

% All possible BS and UE antennas
Nz = 5;
RIS = size(RISs,2);         % Nº of RIS
Nris = sum(Ny)*Nz;          % Nº total RIS elements

% For each y-coordinate, compute the complete channel and the parameters
% of each type of transmission
for a = 1:size(y,2)
    % New UE antenna coordinates and distance between BS-UE
    coord_rx = UE1 + y(a)*[0,1,0];   % Moving
    coord_rx(2,:) = UE2;                    % UE2, fixed location

    dbu = norm(coord_rx(1,:)-coord_tx(1,:));

    % If dbu<10, the pathloss equation cannot be used, therefore all the
    % possible parameters to be evaluated will be null
    if(dbu<=10)   % Moving
        % Alpha in RSM
        al_bu(a) = 0;       % For direct channel
        al(a) = 0;          % For RIS-aided channel
        al_no(a) = 0;
        BERe_bu(a,:)= 0.5.*[1,1];
        BERe_t(a,:) = 0.5.*[1,1];
        alpha_hc(a) = 0;
        alpha_hc_no(a) = 0;
    elseif(coord_rx(1,:) == coord_rx(2,:))
        % Alpha in RSM
        al_bu(a) = 0;       % For direct channel
        al(a) = 0;          % For RIS-aided channel
        al_no(a) = 0;
        BERe_bu(a,:)= 0.5.*[1,1];
        BERe_t(a,:) = 0.5.*[1,1];
        alpha_hc(a) = 0;
        alpha_hc_no(a) = 0;
    else
        % Calculate direct channel
        [Hbu_og,beta_bu] = NF_bu(coord_tx,coord_rx);
        coord_obs = obs_props{1};
        cen_obs = obs_props{4};
        Hbu = channel_obs(coord_obs,cen_obs,coord_tx,coord_rx,Hbu_og);
        % Hbu = Hbu_og;
        Hbu_og = Hbu./beta_bu;
        for r = 1:RIS
            % For each RIS
            % All element locations
            coord_ris = COORD_RIS(RISs{r},Nz,Ny(r),lam,ang_RIS{r});
            % dbr = norm(coord_ris(1,:)-coord_tx(1,:)); % Minimum distance BS - RIS
            % dru = norm(coord_rx(1,:)-coord_ris(1,:)); % Minimum distance RIS - UE

            % Calculate RIS-UE channel (Hru) and BS-RIS channel (Hbr)
            [Hbr{r},Hru_aux,s_path] = NF_Hc(Nz,Ny(r),coord_tx,coord_rx,coord_ris,ang_RIS{r});
            Hbr{r} = Hbr{r}*s_path;
            Hru{r} = channel_obs(coord_obs,cen_obs,coord_ris,coord_rx,Hru_aux);
        end
        % Normalize
        % matHbr = cell2mat(Hbr.');
        matHbr = cell2mat(Hbr.')./beta_bu;
        matHru = cell2mat(Hru);
        % Initial random phases for the RIS coefficients
        random_phases = rand(Nris,1)*2*pi;
        % Matrix of RIS coefficients with no optimization
        % phases_no = diag(exp(1i*random_phases));

        % Optimize RIS phases to maximize alpha
        [phases_rsm] = RIS_opt_ZF(random_phases, Hbu_og, matHbr, matHru);
        % Compund channel
        Hc_rsm = beta_bu.*matHru*phases_rsm*matHbr; % RSM optimization
        Hbu = Hbu_og*beta_bu;
        % Complete channel
        Ht_rsm = Hbu + Hc_rsm;

        Ht_no = Hbu + beta_bu.*matHru*diag(exp(1i*random_phases))*matHbr;

        % Alpha in RSM with ZF
        al_bu(a) = alpha_ZF(Hbu);                        % Alpha for direct channel
        al(a) = alpha_ZF(Ht_rsm);                        % Alpha for RIS-aided channel + It.Alg RSM
        al_no(a) = alpha_ZF(Ht_no);
        % BER with error for RSM: Perfect estimation
        B_bu = Hbu'*inv(Hbu*Hbu');
        B = Ht_rsm'*inv(Ht_rsm*Ht_rsm');
        
        BERe_bu(a,:) = BER_4QAM_error(alpha_ZF(Hbu),Ptot,var2,B_bu,Nris,T,4);
        BERe_t(a,:) = BER_4QAM_error(alpha_ZF(Ht_rsm),Ptot,var2,B,Nris,T,4);

        BERe_bu16(a,:) = BER_4QAM_error(alpha_ZF(Hbu),Ptot,var2,B_bu,Nris,T,16);
        BERe_t16(a,:) = BER_4QAM_error(alpha_ZF(Ht_rsm),Ptot,var2,B,Nris,T,16);

        alpha_hc(a) = alpha_ZF(Hc_rsm);
        alpha_hc_no(a) = alpha_ZF(beta_bu.*matHru*diag(exp(1i*random_phases))*matHbr);
    end
end
INFO = {al_bu,al,BERe_bu,BERe_t,BERe_bu16,BERe_t16,alpha_hc,al_no,alpha_hc_no};

varargout = {INFO};
end
