function c = infoMAP(varargin)
% Configures the map plots
% INPUTS:
%   title: String containing the plot title (MIMO MxN, RIS, Nr)
%   lims: 0 -> auto
%         [min,max]
tl = varargin{1};       % Figure title
if(nargin>1)
    lims=varargin{2};   % Colorbar limits
    if lims == 0
        lims ='auto';
    end
else
    lims='auto';
end
colormap("jet"); % turbo
c = colorbar;
xlabel('x (m)','Interpreter','latex');
ylabel('y (m)','Interpreter','latex');
title(tl,'Interpreter','latex');
xlim auto
ylim auto
clim(lims)
end