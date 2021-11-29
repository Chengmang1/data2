
function BOA()

load coordinates.mat;
load dvhop1_result.mat;
load neighbor.mat;
tic
%% 
unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n; 
for num_un_node=unknown_node_index    
    select_anchors_index=intersect( find(dis_table(:,num_un_node)~=0), find(dis_table(:,num_un_node)~= Inf) );
    select_anchors_n=length(select_anchors_index);          
    unknown_to_anchors_dist=dis_table(select_anchors_index,num_un_node);    
    neighboring_anchor_n=select_anchors_n;

    A_node=all_nodes.estimated(select_anchors_index,:); 
    d=unknown_to_anchors_dist;                         
%%BOA

NP=30;
dim=2;
Max_iter_BOA=200;
ub=100;
lb=0;
p=0.6;                     
power_exponent=0.1;       
sensory_modality=0.01;    
Convergence_curveBOA=zeros(1,Max_iter_BOA);
Sol=rand(NP,dim)*(ub-lb)+lb;
fitness_BOA=zeros(1,NP);
for i=1:NP
    fitness_BOA(i)=fitness(Sol(i,1),Sol(i,2), A_node,d,neighboring_anchor_n);   
end
[fmin,I]=min(fitness_BOA);
best_pos=Sol(I,:);   
S=Sol;    
for t=1:Max_iter_BOA
  
        for i=1:NP 
            Fitnew=fitness(S(i,1),S(i,2), A_node,d,neighboring_anchor_n);      
            FP=(sensory_modality*(Fitnew^power_exponent));    
            if rand<p   
                dis = rand * rand * best_pos - Sol(i,:);       
                S(i,:)=Sol(i,:)+dis*FP;  
            else
              epsilon=rand;
              JK=randperm(NP);
              dis=epsilon*epsilon*Sol(JK(1),:)-Sol(JK(2),:);
              S(i,:)=Sol(i,:)+dis*FP;            
            end
            S(i,:)=simplebounds(S(i,:),lb,ub);
            Fitnew=fitness(S(i,1),S(i,2), A_node,d,neighboring_anchor_n);   
            if (Fitnew<=fitness_BOA(i))
                Sol(i,:)=S(i,:);
                fitness_BOA(i)=Fitnew;
            end
           if Fitnew<=fmin
                best_pos=S(i,:);
                fmin=Fitnew;
           end
        end        
         sensory_modality=sensory_modality_NEW(sensory_modality, Max_iter_BOA);
         Convergence_curveBOA(t)=fmin;
         Position_BOA(num_un_node,2*t-1:2*t)= best_pos;
end
        nodes_estimated(num_un_node,:)=Position_BOA(num_un_node,:);
        all_nodes.anc_flag(num_un_node)=2;
end
       all_nodes.estimated_BOA=nodes_estimated;
save BOA.mat all_nodes comm_r dis_table Max_iter_BOA;
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