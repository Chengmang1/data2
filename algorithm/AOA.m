function [Convergence_curve_AOA] = AOA()
%%%--------------Archimedes optimization algorithm:AOA------------------%%%
clear
clc
for kk=1:100
load details.mat
Max_iter=50;
SearchAgents_no=30;
C3=1;C4=2;
C1=2;C2=6;
u=0.9;l=0.1;   %paramters in Eq. (12)
X=lb+rand(SearchAgents_no,dim).*(ub-lb);%initial positions Eq. (4)
den=rand(SearchAgents_no,dim); % Eq. (5)
vol=rand(SearchAgents_no,dim);  %Με»ύ
acc=lb+rand(SearchAgents_no,dim).*(ub-lb);% Eq. (6)  
for i=1:SearchAgents_no 
    Y(i)=fobj(X(i,:));
end
[Scorebest, Score_index] = min(Y);  
Xbest = X(Score_index,:);
den_best=den(Score_index,:);  
vol_best=vol(Score_index,:);     
acc_best=acc(Score_index,:);    
acc_norm=acc;        

%%~~~~~~~~Enter the cycle~~~~~~~~~~~~
for t = 1:Max_iter
    TF=exp(((t-Max_iter)/(Max_iter)));   % Eq. (8)
    if TF>1
        TF=1;
    end
    d=exp((Max_iter-t)/Max_iter)-(t/Max_iter); % Eq. (9)  
    acc=acc_norm;
    r=rand();
    for i=1:SearchAgents_no
        den(i,:)=den(i,:)+r*(den_best-den(i,:));   % Eq. (7) 
        vol(i,:)=vol(i,:)+r*(vol_best-vol(i,:));
        if TF<.45%collision
            mr=randi(SearchAgents_no);
            acc_temp(i,:)=(den(mr,:)+(vol(mr,:).*acc(mr,:)))./(rand*den(i,:).*vol(i,:));   % Eq. (10)
        else
            acc_temp(i,:)=(den_best+(vol_best.*acc_best))./(rand*den(i,:).*vol(i,:));   % Eq. (11)
        end
    end
    
    acc_norm=((u*(acc_temp-min(acc_temp(:))))./(max(acc_temp(:))-min(acc_temp(:))))+l;   % Eq. (12)
    for i=1:SearchAgents_no
        if TF<0.4
            for j=1:size(X,2)
                mrand=randi(SearchAgents_no);
                Xnew(i,j)=X(i,j)+C1*rand*acc_norm(i,j).*(X(mrand,j)-X(i,j))*d;  % Eq. (13)
            end
        else
            for j=1:size(X,2)
                p=2*rand-C4;  % Eq. (15)
                T=C3*TF;
                if T>1
                    T=1;
                end
                if p<.5
                    Xnew(i,j)=Xbest(j)+C2*rand*acc_norm(i,j).*(T*Xbest(j)-X(i,j))*d;  % Eq. (14)
                else
                    Xnew(i,j)=Xbest(j)-C2*rand*acc_norm(i,j).*(T*Xbest(j)-X(i,j))*d;
                end
            end
        end
    end
for i=1:SearchAgents_no
    for j=1:dim
        if Xnew(i,j)>ub
            Xnew(i,j)=ub;
        elseif Xnew(i,j)<lb
            Xnew(i,j)=lb;
        end
    end
end
    for i=1:SearchAgents_no
        v=fobj( Xnew(i,:));
        if v<Y(i)
            X(i,:)=Xnew(i,:);
            Y (i)=v;
        end
    end
    [var_Ybest,var_index] = min(Y);
    if var_Ybest<Scorebest
        Scorebest=var_Ybest;
        Score_index=var_index;
        Xbest = X(var_index,:);
        den_best=den(Score_index,:);
        vol_best=vol(Score_index,:);
        acc_best=acc_norm(Score_index,:);
    end
    Convergence_curve_AOA(t)=var_Ybest;
end

KKK(kk,:)=Convergence_curve_AOA(1,:);
end
abc=0;
Convergence_curve_AOA=zeros(1,Max_iter);
for i=1:Max_iter
    mmm(i)=sum(KKK(:,i));
    Convergence_curve_AOA(i)=mmm(i)/100;
for j=1:30
    ggg(j,i)=Convergence_curve_AOA(i)-KKK(j,i);
    abc=ggg(:,i)'*ggg(:,i); 
end
   Std_AOA(i)=sqrt(1/100*abc);
end
save AOA.mat KKK Convergence_curve_AOA Std_AOA;

