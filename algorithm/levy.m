function [z] = levy(n,m,beta)

    num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator ���ڷ���
    
    den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator���ڷ�ĸ

    sigma_u = (num/den)^(1/beta);% Standard deviation��׼ƫ��

    u = random('Normal',0,sigma_u,n,m);   %�������һ��nxm�ķ�����̬�ֲ�N��0��sigma_u���ľ���
    
    v = random('Normal',0,1,n,m);%�������һ��nxm�ķ�����̬�ֲ�N��0��1���ľ���

    z =u./(abs(v).^(1/beta));

  
  end

