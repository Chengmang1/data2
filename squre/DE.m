function DE()

load coordinates.mat;
load dvhop1_result.mat;
load neighbor.mat;
tic
%% DE
unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n; 
for num_un_node=unknown_node_index    
    select_anchors_index=intersect( find(dis_table(:,num_un_node)~=0), find(dis_table(:,num_un_node)~= Inf) );
    select_anchors_n=length(select_anchors_index);         
    unknown_to_anchors_dist=dis_table(select_anchors_index,num_un_node);  
    neighboring_anchor_n=select_anchors_n;

    A_node=all_nodes.estimated(select_anchors_index,:); 
    d=unknown_to_anchors_dist;                   
   
    NP=20;      
    D=2;       
    Max_iter_DE=200;      
    F0=0.9;     
    CR=0;      
    a=0;        
    b=100;
    x=zeros(NP,D);   
    v=zeros(NP,D);    
    u=zeros(NP,D);    
    ob=Inf(NP,1);
    x=rand(NP,D)*(b-a)+a;
    trace(1)=Inf;
    for gen=1:Max_iter_DE
        for i=1:1:NP
            ob(i) = fitness(u(i,1),u(i,2), A_node,d,neighboring_anchor_n);
        end
        for m=1:NP
            r1=randi([1,NP],1,1);
            while(r1==m)
                r1=randi([1,NP],1,1);
            end

            r2=randi([1,NP],1,1);
            while(r2==r1)||(r2==m)
                r2=randi([1,NP],1,1);
            end
            r3=randi([1,NP],1,1);
            while(r3==m)||(r3==r2)||(r3==r1)
                r3=randi([1,NP],1,1);
            end
            v(m,:)=x(r1,:)+F0*(x(r2,:)-x(r3,:));  %

        end
        r=randi([1,D],1,1);  
        for n=1:D
            cr=rand;
            if (cr<=CR)||(n==r)
                u(:,n)=v(:,n);
            else
                u(:,n)=x(:,n);
            end
        end
        for m=1:NP
            for n=1:D
                if u(m,n)<a
                    u(m,n)=a;
                end
                if u(m,n)>b
                    u(m,n)=b;
                end
            end
        end
        for m=1:NP
            ob_1(m)=fitness(u(m,1),u(m,2), A_node,d,neighboring_anchor_n); 
        end
        for m=1:NP
            if ob_1(m)<ob(m)
                x(m,:)=u(m,:);
                node_DE=u(m,:);
            else
                x(m,:)=x(m,:);
                node_DE=u(m,:);
            end
        end
    Xbest(num_un_node,2*gen-1:2*gen)=node_DE;
    end
     nodes_estimated(num_un_node,:)=Xbest(num_un_node,:);
     all_nodes.anc_flag(num_un_node)=2;
end
     all_nodes.estimated_DE=nodes_estimated;
save '../squre/DE_result.mat' all_nodes comm_r dis_table Max_iter_DE;
time_DE=toc
end