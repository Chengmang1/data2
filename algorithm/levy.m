function [z] = levy(n,m,beta)

    num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator 用于分子
    
    den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator用于分母

    sigma_u = (num/den)^(1/beta);% Standard deviation标准偏差

    u = random('Normal',0,sigma_u,n,m);   %随机生成一个nxm的服从正态分布N（0，sigma_u）的矩阵
    
    v = random('Normal',0,1,n,m);%随机生成一个nxm的服从正态分布N（0，1）的矩阵

    z =u./(abs(v).^(1/beta));

  
  end

