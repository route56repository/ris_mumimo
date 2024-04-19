%PLOTRSM Plots RSM simulations for Scenario 1
search = input('SEARCH FROM FILE (1 (yes), 0 (no)): ');
if(search == 1)
    clear all;
    currentFolder = pwd;
    files = dir('*.mat');
    if(size(files,1)>1)
        what
        index_file = input('Choose file: ');
        load(files(index_file).name);
    else
        load(files.name);
    end
end

%% SIMULATION SETUP
% figure;
% l1 = plotCOORD(angBS,angUE,ang_RIS,BS,coord_rx,RIS_i,1);
% title('Top view simulation setup');
% l1.Location = 'best';
% title(l1,['MIMO ',num2str(Mtx),'x',num2str(Nrx)]);

%% ALPHA RSM
figure
plot(Nris,alpha_bu);
title('\alpha RSM');
hold on
plot(Nris, alpha);
lg2 = legend('Direct channel','Opt(1) RIS-aided channel','Location','best');
title(lg2,['MIMO ', num2str(Mtx), 'x', num2str(Nrx)]);
xlabel('Nº of RIS elements');
ylabel('\alpha');

%% ABEP with perfect estimation
% figure;
% semilogy(Nris,BER_bu);
% hold on;
% semilogy(Nris,BER_t);
% title('BER for 4-QAM: Perfect estimation')
% lgg = legend('Direct channel','RIS-aided channel','Location','best');
% title(lgg,['SNR = Pt/\sigma^2 = ', num2str(10*log10(Ptot/var2)), ' dB']);
% xlabel('Nº of RIS elements');
% ylabel('Pb')

%% ABEP with error estimation
figure;
semilogy(Nris,BER_bu);
semilogy(Nris,BER_t);
semilogy(Nris,BERe_bu(:,1));
hold on;
semilogy(Nris,BERe_bu(:,2));
semilogy(Nris,BERe_t(:,1));
semilogy(Nris,BERe_t(:,2));
title('ABEP for 4-QAM: Error estimation')
lgg = legend('Direct Channel','RIS-aided channel','Direct channel UE 1','Direct channel UE 2','RIS-aided channel UE 1','RIS-aided channel UE 2','Location','best');
title(lgg,['T = Nr+1']);
xlabel('Nº of RIS elements');
ylabel('Pb')

% COMPARACIÓN
figure;
semilogy(Nris,BER_bu,'LineStyle','--','LineWidth',2,'DisplayName','hd - perfect');
hold on;
semilogy(Nris,BER_t,'LineStyle','--','LineWidth',2,'DisplayName','ht - perfect');

semilogy(Nris,BERe_bu,'LineStyle','-','LineWidth',2,'DisplayName',['hd - errors','hd2 - errors']);
hold on;
semilogy(Nris,BERe_t(:,1),'LineStyle','-','LineWidth',2,'DisplayName','ht1 - errors');
semilogy(Nris,BERe_t(:,2),'LineStyle','-','LineWidth',2,'DisplayName','ht2 - errors');
title('ABEP for 4-QAM: Error estimation')
lgg = legend;
lgg.Location = 'best';
title('BER for 4-QAM')
xlabel('Nº of RIS elements');
ylabel('Pb,k')


