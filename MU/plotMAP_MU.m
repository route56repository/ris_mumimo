function plotMAP_MU(varargin)
% LOAD FILES
files = dir('*.mat');

% current_Folder = pwd;
% RIS_element_size = current_Folder(end-4);
% if(~strcmp(current_Folder(end-5),'_'))
%     RIS_element_size=current_Folder(end-5:end-4);
% end
RIS_element_size='0.5';
% LOAD PARAMETERS
info = load(files(end).name);
BS = info.BS;
UE2 = info.UE2;
RIS = info.RISmat;
angBS = info.angBS;

ang_RIS = info.ang_RIS;
NRIS = info.NRIS;
obstacles = info.obs_props;

m = info.m;
n = info.n;

i1 = 1;
i2 = 1;

Nrx = 2;
system_parameters;

for i=1:length(files)-1
    a = load(files(i).name);
    if(i1 == m/n+1)
        i1 = 1;
        i2 = i2+1;
    end

    cell_al_bu{i1,i2} = a.al_bu';
    cell_al{i1,i2} = a.al';

    i1 = i1+1;
end
Mtx = files(i).name(5);

x_all = 0:n/10:m;
y_all = 0:n/10:m;

% strlg = ['\textbf{$a=b=$',RIS_element_size,'$\lambda_c$, M = ',num2str(a.Mtx),', K = ',num2str(a.Nrx),', ',num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS)),'}'];
% strlg_bu = ['\textbf{M = ',num2str(a.Mtx),', K = ',num2str(a.Nrx),'}'];

% NO M,K, NRIS
strlg = ['\textbf{$a=b=$',RIS_element_size,'$\lambda_c$, Nr = ', num2str(sum(NRIS)),'}'];
strlg_bu = ['\textbf{M = ',num2str(a.Mtx),', K = ',num2str(a.Nrx),'}'];
% % PLOT RIS AIDED CHANNEL

% ALPHA IN RSM
% RIS OPT
lims_SNR = [0,10];

% % Direct channel
% figure
% hold on
% SNR_bu = 10*log10(abs((Ptot/var2).*cell2mat(cell_al_bu)'))';
% imagesc(x_all,y_all,SNR_bu);
% tt = 'SNR - Direct channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,NaN,ang_RIS,UE2,obstacles);
% title(lg,strlg_bu,'Interpreter','latex');
% 
% 
% % RIS-aided channel (Ht)
% figure;
% hold on
% SNR_t = 10*log10(abs((Ptot/var2).*cell2mat(cell_al)'))';
% imagesc(x_all,y_all,SNR_t);
% tt = 'SNR - RIS-aided channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');

% RIS-aided NO OPTIMIZATION
% figure
% hold on
% SNR_bu = 10*log10(abs((Ptot/var2).*cell2mat(cell_al_no)'))';
% imagesc(x_all,y_all,SNR_bu);
% tt = 'SNR - RIS-aided NO OPT channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');

% lims_SNR = [-100,-50];
% % RIS channel (Hc)
% figure;
% hold on
% SNR_t = 10*log10(abs((Ptot/var2).*cell2mat(cell_al_c)'))';
% imagesc(x_all,y_all,SNR_t);
% tt = 'SNR - RIS channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');
% 
% 
% % RIS channel (Hc - NO opt)
% figure;
% hold on
% SNR_t = 10*log10(abs((Ptot/var2).*cell2mat(cell_al_c_no)'))';
% imagesc(x_all,y_all,SNR_t);
% tt = 'SNR - RIS NO OPT channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');

%% BER
MQAM = 4;
lims_BER=[-5,0];
%lims_BER = 0;
figure
% tiledlayout(2,2);
% nexttile
hold on
BER_mat_bu = log10(BER_MQAM(cell2mat(cell_al_bu)',Ptot,var2,MQAM))';
imagesc(x_all,y_all,BER_mat_bu);
t1 = ['BER - Direct channel (log), ', num2str(MQAM),'-QAM'];
infoMAP(t1,lims_BER);
lg=TopView(BS,angBS,NaN,ang_RIS,UE2);
title(lg,strlg_bu,'Interpreter','latex');

figure
% nexttile
hold on
BER_mat = log10(BER_MQAM(cell2mat(cell_al)',Ptot,var2,MQAM))';
imagesc(x_all,y_all,BER_mat);
t2 = ['BER - RIS aided (log), ', num2str(MQAM),'-QAM'];
infoMAP(t2,lims_BER);
lg=TopView(BS,angBS,RIS,ang_RIS,UE2);
title(lg,strlg,'Interpreter','latex');

% figure
% % nexttile
% hold on
% BER_mat_error_1 = log10(cell2mat(cell_ber1_bu)')';
% imagesc(x_all,y_all,BER_mat_error_1);
% t2 = ['BER - Dir. Path (log) - Error Estimation UE1, ', num2str(MQAM),'-QAM'];
% infoMAP(t2,lims_BER);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');
% 
% figure
% % nexttile
% hold on
% BER_mat_error_1 = log10(cell2mat(cell_ber2_bu)')';
% imagesc(x_all,y_all,BER_mat_error_1);
% t2 = ['BER - Dir. Path (log) - Error Estimation UE2, ', num2str(MQAM),'-QAM'];
% infoMAP(t2,lims_BER);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');
% 
% figure
% % nexttile
% hold on
% BER_mat_error_1 = log10(cell2mat(cell_ber1_t)')';
% imagesc(x_all,y_all,BER_mat_error_1);
% t2 = ['BER - RIS aided (log) - Error Estimation UE1', num2str(MQAM),'-QAM'];
% infoMAP(t2,lims_BER);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');
% 
% figure
% % nexttile
% hold on
% BER_mat_error_1 = log10(cell2mat(cell_ber2_t)')';
% imagesc(x_all,y_all,BER_mat_error_1);
% t2 = ['BER - RIS aided (log) - Error Estimation UE2', num2str(MQAM),'-QAM'];
% infoMAP(t2,lims_BER);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');

% MQAM = 16;
% figure
% % nexttile
% hold on
% BER_mat_bu16 = log10(BER_MQAM(cell2mat(cell_al_bu)',Ptot,var2,MQAM))';
% imagesc(x_all,y_all,BER_mat_bu16);
% t1 = ['BER - Direct channel (log), ', num2str(MQAM),'-QAM'];
% c=infoMAP(t1,lims_BER);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg_bu,'Interpreter','latex');
% 
% figure;
% % nexttile
% hold on
% BER_mat16 = log10(BER_MQAM(cell2mat(cell_al)',Ptot,var2,MQAM))';
% imagesc(x_all,y_all,BER_mat16);
% t2 = ['BER - RIS aided (log), ', num2str(MQAM),'-QAM'];
% infoMAP(t2,lims_BER);
% lg=TopView(BS,angBS,RIS,ang_RIS,UE2,obstacles);
% title(lg,strlg,'Interpreter','latex');


% CDF
% % ABEP
% figure
% ax = axes;
% xlim([1e-5,0.5]);
% ax.XAxis.Scale = 'log';
% xlabel('log_1_0(ABEP)');
% hold on
% cdfplot(vec((cell2mat(mat_ABEP_bu))));
% cdfplot(vec((cell2mat(mat_ABEP))));
% ylabel('CDF');
% title('CDF of ABEP');
% l123 = legend('Direct channel','RIS-aided channel','Location','best');
% % ALPHA
% figure
% xlim([1e-15,1e-5]);
% hold on
% cdfplot(real(abs(vec(cell2mat(mat_al_bu)))));
% cdfplot(vec(cell2mat(mat_al)));
% ylabel('CDF');
% title('CDF of log_1_0(\alpha)');
% legend('Direct channel','RIS-aided channel','Location','best');

end