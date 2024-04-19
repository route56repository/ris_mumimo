function Pb = BER_MQAM(alpha,Ptot,var2,M)
%BER_MQAM Compmutes the BER of an M-QAM Modulation given some inputs
% parameters such as:
% alpha
% Ptot: Total power transmitted
% var2: Noise power
% M
SNR = alpha.*(Ptot/var2);
Pb = 4/log2(M)*(1-1/sqrt(M))*qfunc(sqrt(3*SNR/(M-1)));
end

