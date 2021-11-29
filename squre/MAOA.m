function MAOA()
% Initialization
load coordinates.mat;
load dvhop1_result.mat;
load neighbor.mat;
tic;
for num_un_node=all_nodes.anchors_n+1:all_nodes.nodes_n
    select_anchors_index=intersect( find(dis_table(:,num_un_node)~=0), find(dis_table(:,num_un_node)~= Inf) );
    select_anchors_n=length(select_anchors_index);          
    unknown_to_anchors_dist=dis_table(select_anchors_index,num_un_node);    
    neighboring_anchor_n=select_anchors_n;
    A_node=all_nodes.estimated(select_anchors_index,:); 
    d=unknown_to_anchors_dist;                      

NP=30;
dim=2;
a=0;        
b=100;    
Max_iter=200;
C3=1;C4=2;
C1=2;C2=6;
r1=1;r2=1.5;
u=0.9;l=0.1;  
X=initializationNew(NP,dim,b,a);
den=rand(NP,dim); 
vol=rand(NP,dim);  
acc=a+rand(NP,dim).*(b-a);
pp=X;
pden=den;
pvol=vol;
pbest=rand(NP,1);
for i=1:NP   
    pbest(i)=fitness(pp(i,1),pp(i,2),A_node,d,neighboring_anchor_n);
end
[Scorebest, Score_index] = min(pbest);  
Xbest =X(Score_index,:);
den_best=den(Score_index,:); 
vol_best=vol(Score_index,:);  
acc_best=acc(Score_index,:);   
acc_norm=acc;        
%%
for t =1:Max_iter
    TF=exp((t-Max_iter)/(Max_iter));   
    dd=exp((Max_iter-t)/Max_iter)-(t/Max_iter);
    acc=acc_norm;

    for i=1:NP
        den(i,:)=den(i,:)+r1*(pden(i,:)-den(i,:))+r2*(den_best-den(i,:));   
        vol(i,:)=vol(i,:)+r1*(pvol(i,:)-vol(i,:))+r2*(vol_best-vol(i,:));
        if TF<0.5
            mr=randi(NP);
            acc_temp(i,:)=(den(mr,:)+(vol(mr,:).*acc(mr,:)))./(rand*den(i,:).*vol(i,:));   
        else
            acc_temp(i,:)=(den_best+(vol_best.*acc_best))./(rand*den(i,:).*vol(i,:));   
        end
    end    
    acc_norm=((u*(acc_temp-min(acc_temp(:))))./(max(acc_temp(:))-min(acc_temp(:))))+l;   
    for i=1:NP
        if TF<=0.5
            for j=1:size(X,2)
                mrand=randi(NP);
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
for k=1:NP
    for m=1:dim
        if  Xnew(k,m)<a | Xnew(k,m)>b
            Xnew(k,m)=a+rand*(b-a);
        end
    end
end
for i=1:NP
    v(i)=fitness(Xnew(i,1),Xnew(i,2),A_node,d,neighboring_anchor_n);
    if  v(i)<pbest(i)
        X(i,:)=Xnew(i,:);
        pbest (i)=v(i);
        pden(i)=den(i);
        pvol(i)=vol(i);
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
    XXbest(num_un_node,2*t-1:2*t)=Xbest;
end  
nodes_estimated(num_un_node,:)=XXbest(num_un_node,:);
all_nodes.anc_flag(num_un_node)=2;
end
all_nodes.estimated_MAOA=nodes_estimated;
save '../squre/MAOA_result.mat' all_nodes comm_r dis_table Max_iter;
time_MAOA=toc
end




