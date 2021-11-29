function [RSS,RSS_NOFADING]=dist2rss(dist,K_i)
%~~~~~~~~~~~~~~~~~~~~~~RIM Model~~~~~~~~~~~~~~~
% ReceivedSignalStrength=SendingPower-DOIAdjustedPathLoss+Fading
% e.g, RSS=Pt-Pl(d0)-10*η*log10(dist/d0)*Ki+Xσ
% Pt:transmit power
% pl(d0):the pass loss for a reference distance of d0
% ηis the path loss exponent
% above parameters are saved in '../Parameters_Of_Models.mat'
% K_i=K_(i-1)+doi; doi~[-DOI,DOI]; 
% dist:distance between sender and receiver(m)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% typical value:Pt=0-4dBm(max),Pl(d0)=55dB(d0=1m),η(2~4)=4(indoor,outdoor)
% Xσ~N(0,σ); σ=4~10(indoor 7, outdoor 4)
    load '../Parameters_Of_Models.mat';
    RSS_NOFADING=Pt-Pl_d0-10*eta*log10(dist/d0).*K_i;
    RSS=RSS_NOFADING+normrnd(0,delta,size(RSS_NOFADING));    %normrnd(A,B)表示从正态分布中生成一个随机数，平均参数A和标准偏差参数B。
end