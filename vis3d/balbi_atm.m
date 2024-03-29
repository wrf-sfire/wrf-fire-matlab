function q=balbi_atm(f,s)
% q=balbi_atm(f,s)
% 
% Get atmospheric inputs for the Balbi model from a wrfout
% 
% in:
%   f   wrfout file namee
%   s   step (frame number in the file)
% out:
%   q   structure
% 
% based on formulas from Derek

if nargin<2
    s=1;
end
p=nc2struct(f,{'QVAPOR','T','P','PB','T2','Q2','PSFC','PSFC','PH','PHB'},{},s)
P = p.p+p.pb;            % air pressure
theta = p.t+300;             % potential temperature in K
% theta = T*(p0/p)^c, p0=1e5, c=0.286 https://en.wikipedia.org/wiki/Potential_temperature    
temp = theta .* (P*1e-5).^0.286;
TV=(1+0.61*p.qvapor).*temp; % virtual temperature
RHO=P./(287*TV);           % air density
EL =(p.ph + p.phb)/9.81; % elevation at w-points
Z = (EL(:,:,1:end-1)+EL(:,:,2:end))/2; % elevation at centers
dZ = (-EL(:,:,1:end-1)+EL(:,:,2:end)); % thickness of layers 
q2 = p.q2;
t2 = p.t2;
psfc = p.psfc;

dp=mean(P(:,:,1)-psfc,'all');
sp=mean(p.psfc,'all');
fprintf('average difference P(:,:,1)-PSFC = %g = %g %s\n',dp,100*dp/sp,'%')
dt=mean(temp(:,:,1)-p.t2,'all');
mt2=big(p.t2);
fprintf('average difference temp(:,:1) - T2 = %g max abs t2=%g\n',dt,mt2)
dz1 = mean(dZ(:,:,1),'all');
fprintf('average thickness of the lowest layer = %g\n',dz1)
rho1=mean(RHO(:,:,1),'all');
fprintf('average air density in the lowest layer = %g\n',rho1)
qv1=mean(p.qvapor(:,:,1),'all');
fprintf('vapor mixing ratio in the lowest layer = %g\n',qv1)
mq2=mean(p.q2,'all');
fprintf('vapor mixing ratio at 2m = %g\n',mq2)

tv2=(1+0.61*q2).*t2;           % virtual temperature
rho2=psfc./(287*tv2);           % air density
mrho2=mean(rho2,'all');
fprintf('average surface air density = %g\n',mrho2)

end
