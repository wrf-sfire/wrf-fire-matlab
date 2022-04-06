% set matlab path to include files in wrf/other/Matlab
format compact
p=mfilename('fullpath');
p=p(1:end-7);
d={  p,...
    [p,'/vis'],...
    [p,'/util1_jan'],...
    [p,'/netcdf'],...
    [p,'/cycling'],...
    [p,'/vis3d'],...
    [p,'/debug'],...
    [p,'/perimeter'],...
    [p,'/detection'],...
    [p,'/detect_ignition'],...
    [p,'/detect_ignition/new_likelihood'],...
    [p,'/chem'],...
    [p,'/impact'],...
    [p,'/fft'],...
    [p,'/quicwind'],...
    [p,'/femwind']
};
for i=1:length(d),
    s=d{i};
    addpath(s)
    disp(s)
    ls(s)
end
clear p d i s
