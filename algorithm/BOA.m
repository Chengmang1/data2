%_____________________________________________________________________________________________ %
%  Butterfly Optimization Algorithm (BOA) source codes demo V1.0                               %
%                                                                                              %
%  Author and programmer: Sankalap Arora                                                       %
%                                                                                              %
%         e-Mail: sankalap.arora@gmail.com                                                     %
%                                                                                              %
%  Main paper: Sankalap Arora, Satvir Singh                                                    %
%              Butterfly optimization algorithm: a novel approach for global optimization	   %
%              Soft Computing, in press,                                                       %
%              DOI: https://doi.org/10.1007/s00500-018-3102-4                                  %
%___________________________________________________________________________________________   %
%
function [Convergence_curve_BOA]=BOA()

%BOA(25,100)
clear,clc;
tic;
for kk=1:100
load details.mat
Max_iter=200;
SearchAgents_no=30;
p=0.6;                       
power_exponent=0.1;       
sensory_modality=0.01;    
Convergence_curve_BOA=zeros(1,Max_iter);
Sol=initialization(SearchAgents_no,dim,ub,lb);
fitness=zeros(1,SearchAgents_no);
for i=1:SearchAgents_no
    fitness(i)=fobj(Sol(i,:));
end

[fmin,I]=min(fitness);
best_pos=Sol(I,:);    
S=Sol;   

%~~~~~~~~~Enter the cycle~~~~~~~~~~~
for t=1:Max_iter
  
        for i=1:SearchAgents_no 

            Fitnew=fobj(S(i,:));     
            FP=(sensory_modality*(Fitnew^power_exponent));    
            if rand<p   
                dis = rand * rand * best_pos - Sol(i,:);        %Eq. (2) in paper
                S(i,:)=Sol(i,:)+dis*FP;    
            else
              epsilon=rand;
              JK=randperm(SearchAgents_no);
              dis=epsilon*epsilon*Sol(JK(1),:)-Sol(JK(2),:);
              S(i,:)=Sol(i,:)+dis*FP;                         %Eq. (3) in paper
            end
            S(i,:)=simplebounds(S(i,:),lb,ub);
            Fitnew=fobj(S(i,:));  %Fitnew
            if (Fitnew<=fitness(i))
                Sol(i,:)=S(i,:);
                fitness(i)=Fitnew;
            end
           if Fitnew<=fmin
                best_pos=S(i,:);
                fmin=Fitnew;
           end
        end        
         sensory_modality=sensory_modality_NEW(sensory_modality, Max_iter);
         Convergence_curve_BOA(t)=fmin;
end
KKK(kk,:)=Convergence_curve_BOA(1,:);
end
abc=0;
Convergence_curve_BOA=zeros(1,Max_iter);
for i=1:Max_iter
    mmm(i)=sum(KKK(:,i));
    Convergence_curve_BOA(i)=mmm(i)/100;
for j=1:100
    ggg(j,i)=Convergence_curve_BOA(i)-KKK(j,i);
    abc=ggg(:,i)'*ggg(:,i); 
end
   Std_BOA(i)=sqrt(1/100*abc);
end
save BOA.mat;
end


function s=simplebounds(s,Lb,Ub)
  % Apply the lower bound
  ns_tmp=s;
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb;
  

  J=ns_tmp>Ub;
  ns_tmp(J)=Ub;
  % Update this new move 
  s=ns_tmp;
end
function y=sensory_modality_NEW(x,Ngen)
y=x+(0.025/(x*Ngen));
end