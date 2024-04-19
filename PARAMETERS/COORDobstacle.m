function varargout = COORDobstacle(varargin)
%CHANNEL_OBS The channel if the are obstacles between TX and RX
%   If obstacle between BS-UE, the direct channel suffers a 30dB
%   attenuation
num_obs = varargin{1};      % Number of obstacles
len_obs = varargin{2};      % length of obstacle
cen_obs = varargin{3};      % center of obstacle
or_obs = varargin{4};       % orientation of obstacle ('-' = 0 or '|' = pi/2)

% Normal line to obstacle '-' = [0,+/-1]
% Normal line to obstacle '|' = [+/-1,0]

% FOR EACH OBSTACLE
coord_obs = cell(1,num_obs);
for o = 1:num_obs
    obs = [cos(or_obs(o)),sin(or_obs(o))].*(-len_obs/2) + cen_obs(o,:);
    coord_obs{o} = [obs;[cos(or_obs(o)),sin(or_obs(o))].*(len_obs/2) + cen_obs(o,:)];
end

varargout = {coord_obs};
end