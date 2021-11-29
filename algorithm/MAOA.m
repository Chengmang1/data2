function [Convergence_curve_MAOA] = MAOA()
clear,clc;
tic;
for kk=1:100
load details.mat
Max_iter=50;
SearchAgents_no=30;
C1=2;C2=6;
C3=1;C4=2;
u=0.9;l=0.1;   %paramters in Eq. (12)
X=initializationNew(SearchAgents_no,dim,ub,lb);
den=rand(SearchAgents_no,dim); % Eq. (5)
vol=rand(SearchAgents_no,dim);  
acc=lb+rand(SearchAgents_no,dim).*(ub-lb);% Eq. (6)  
pp=X;
pbest=rand(SearchAgents_no,1);
for i=1:SearchAgents_no  
    pbest(i)=fobj(pp(i,:));
end
pden=den;
pvol=vol;
[Scorebest, Score_index] = min(pbest);  
Xbest = X(Score_index,:);
den_best=den(Score_index,:);  
vol_best=vol(Score_index,:);     
acc_best=acc(Score_index,:);    
acc_norm=acc;          

%%~~~~~~~~Enter the cycle~~~~~~~~~~~~
for t = 1:Max_iter
    TF=exp((t-Max_iter)/(Max_iter));   
    dd=exp((Max_iter-t)/Max_iter)-(t/Max_iter); 
    acc=acc_norm;
    r1=1.8;r2=0.5;
    for i=1:SearchAgents_no
        den(i,:)=den(i,:)+r1*(pden(i,:)-den(i,:))+r2*(den_best-den(i,:));  
        vol(i,:)=vol(i,:)+r1*(pvol(i,:)-vol(i,:))+r2*(vol_best-vol(i,:));
        if TF<0.5
            mr=randi(SearchAgents_no);
            acc_temp(i,:)=(den(mr,:)+(vol(mr,:).*acc(mr,:)))./(rand*den(i,:).*vol(i,:));   
        else
            acc_temp(i,:)=(den_best+(vol_best.*acc_best))./(rand*den(i,:).*vol(i,:));   
        end
    end    
    acc_norm=((u*(acc_temp-min(acc_temp(:))))./(max(acc_temp(:))-min(acc_temp(:))))+l;   
    for i=1:SearchAgents_no
        if TF<=0.5
            for j=1:size(X,2)
                mrand=randi(SearchAgents_no);
                Xnew(i,j)=X(i,j)+C1*rand*acc_norm(i,j).*(X(mrand,j)-X(i,j))*dd;  
            end
        else
                p=2*rand-C4; 
                T=C3*TF;
                if T>1
                    T=1;
                end
                if p<0.5
                    Xnew(i,:)=Xbest+C2*rand*acc_norm(i,:).*(T*Xbest-X(i,:))*dd;  
                else
                    Xnew(i,:)=Xbest-C2*rand*acc_norm(i,:).*(T*Xbest-X(i,:))*dd;
                end
        end
    end
for k=1:SearchAgents_no
    for m=1:dim
        if  Xnew(k,m)<lb | Xnew(k,m)>ub
            Xnew(k,m)=lb+rand*(ub-lb);
        end
    end
end
for i=1:SearchAgents_no
    v(i)=fobj(Xnew(i,:));
    if v(i)<pbest(i)
        X(i,:)=Xnew(i,:);
        pbest(i)=v(i);
        pden(j)=den(j);
        pvol(j)=vol(j);
    end    
end
    [var_Ybest,var_index] = min(pbest);
    if var_Ybest<Scorebest
        Scorebest=var_Ybest;
        Score_index=var_index;
        Xbest = X(var_index,:);
        den_best=den(Score_index,:);
        vol_best=vol(Score_index,:);
        acc_best=acc_norm(Score_index,:);
    end  
    Convergence_curve_MAOA(t)=var_Ybest;
end
     KKK(kk,:)=Convergence_curve_MAOA;
end
abc=0;
Convergence_curve_MAOA=zeros(1,Max_iter);
for i=1:Max_iter
    mmm(i)=sum(KKK(:,i));
    Convergence_curve_MAOA(i)=mmm(i)/100;
for j=1:100
    ggg(j,i)=Convergence_curve_MAOA(i)-KKK(j,i);
    abc=ggg(:,i)'*ggg(:,i); 
end
   Std_MAOA(i)=sqrt(1/100*abc);
end
save MAOA.mat KKK Convergence_curve_MAOA Std_MAOA;
end
