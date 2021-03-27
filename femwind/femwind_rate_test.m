function p=femwind_rate_test
disp('basic convergence speed test')
p=femwind_main
p.graphics=0;
p.sc_all = 1;
p.sc2_all = 1;
p.levels=10;
% params.P_by_x=1;  % coarsening proportioned by x
p=femwind_main(p);
rate = 0.066948270621534;
if abs(p.rate - rate) < 1e-8
    disp('basic convergence rate test OK')
else
    error(sprintf('something changed, expected convergence rate %g got %g diff %g',...
       rate,p.rate,rate-p.rate))
end
end

