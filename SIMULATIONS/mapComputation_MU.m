% CREATES A MAP WITH DIFFERENT INFORMATION
% We measure an mxm (m^2) area in nxn cells every n/10 meters. We compute the
% information for an RSM transmission
folderTest = [folderRIS,'\',strTest];
abcd = 'abcdefghijklmnopqrstuvwxyz';

k=0;

for yi = 0:n:(m-n)
    numTest = 1; %For each x [0-20,20-40,...]-[a,b,c...]
    ymin = yi;
    ymax = ymin + n;
    y = ymin:n/10:(ymax-n/10);
    for xi = 0:n:(m-n)       
        xmin = xi;
        xmax = xmin + n;
        x = xmin:n/10:(xmax-n/10);
        nameTest = abcd(numTest);
        file_test =['MIMO',num2str(Mtx),'_',nameTest,num2str(k),'.mat'];
        completename = [folderTest,'\',file_test];
        if exist(completename,'file')
            disp('FILE ALREADY EXISTS !!')
        else
            for a = 1:size(x,2)
                x_i = x(a);
                % Calculate all information for a fixed x_i coordinate and multiple
                % y coordinates
                INFO = mapCell_MU(coord_tx,UE2,RIS_i,Ny,x_i,y,ang_RIS,T,obs_props);
                disp([num2str(a) '/' num2str(size(x,2)), ' OK']);
                % Save information in different matrices
                al_bu(a,:) = INFO{1};
                al(a,:) = INFO{2};
                BERe_bu = INFO{3};
                BERe_bu1(a,:) = BERe_bu(:,1).';
                BERe_bu2(a,:) = BERe_bu(:,2).';
                BERe_t = INFO{4};
                BERe_t1(a,:) = BERe_t(:,1).';
                BERe_t2(a,:) = BERe_t(:,2).';
                BERe_16bu = INFO{5};
                BERe_16bu1(a,:) = BERe_16bu(:,1).';
                BERe_16bu2(a,:) = BERe_16bu(:,2).';
                BERe_16t = INFO{6};
                BERe_16t1(a,:) = BERe_16t(:,1).';
                BERe_16t2(a,:) = BERe_16t(:,2).';
                alpha_hc(a,:) = INFO{7};
                al_no(a,:) = INFO{8};
                alpha_hc_no(a,:) = INFO{9};
            end      
            % Save the matrices in a mat file
            save([folderTest,'\',file_test]);
            disp(['TEST ',num2str(numTest)]);   
        end
        numTest = numTest + 1;
    end
     k = k+1;
    disp([num2str(yi), ' DONE !!!']);
end