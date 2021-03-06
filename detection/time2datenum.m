function d=time2datenum(t,red)
% convert time in seconds since sim start to datenum
% t     time in seconds since sim start
% red   structure with fields:
%       red.max_tign_g    a reference time as  seconds since sim start
%       red.time          the same time as datenum
% d     time as datenum
d= t/(24*3600) + red.start_datenum;
end