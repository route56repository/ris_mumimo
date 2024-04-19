function Pb = BER_4QAM_error(varargin)

alpha = varargin{1};
P = varargin{2};
noise_power = varargin{3};
B = varargin{4};
Nr = varargin{5};
T = varargin{6};
M = varargin{7};
if nargin>7
    P_UL = varargin{8};
else
    P_UL = P;
end
sigma_e2 = 0;
K = 2;  % Number of users (size(B,1 o 2))

for k = 1:K
    % For each user, we compute the corresponding Pb
    sigma_k2 = 0;
    for l=1:K
        if k==l
            %var(e_kk)
            b_k = B(:,k);
            sigma_e2 = norm(b_k)^2*noise_power/T*(1+Nr)/P_UL ;
        else
            %sigma_k
            b_l = B(:,l);
            sigma_k2 = alpha*P/T/P_UL*noise_power*(1+Nr)*norm(b_l)^2+noise_power;
        end
    end
    K2 = P*alpha/sigma_k2*3/(M-1);
    K1 = 1/sigma_e2 + K2/2;

    Pb(k) = 4*(1-1/sqrt(M))/log2(M)/2/(sqrt(sigma_e2*K1))*exp(-0.5*K2*(1-K2/K1));

end
end