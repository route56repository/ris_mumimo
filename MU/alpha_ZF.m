function P = alpha_ZF(H)
%POT Computes alpha=inv(trace(inv(H*H')))
P = 1/(trace(inv(H*H')));
end