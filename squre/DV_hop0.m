function DV_hop0()
load '../squre/coordinates.mat';
load '../squre/neighbor.mat'; 
if all_nodes.anchors_n<3  
    disp('can not run');    
    return;
end

shortest_path=neighbor_matrix;   
shortest_path=shortest_path+eye(all_nodes.nodes_n)*2;
shortest_path(shortest_path==0)=inf;
shortest_path(shortest_path==2)=0;
for k=1:all_nodes.nodes_n
    for i=1:all_nodes.nodes_n   
        for j=1:all_nodes.nodes_n   
            if shortest_path(i,k)+shortest_path(k,j)<shortest_path(i,j)          
                shortest_path(i,j)=shortest_path(i,k)+shortest_path(k,j);                
            end            
        end        
    end    
end
if ~isempty(find(shortest_path==inf, 1))
    disp('None');
    return;
end

anchor_to_anchor=shortest_path(1:all_nodes.anchors_n,1:all_nodes.anchors_n);
hopsize1=zeros(1,all_nodes.anchors_n );
hopsize=zeros(1,all_nodes.anchors_n );
for i=1:all_nodes.anchors_n      
   hopsize(i)=sum(sqrt(sum(transpose((repmat(all_nodes.true(i,:),all_nodes.anchors_n,1)-all_nodes.true(1:all_nodes.anchors_n,:)).^2))))/sum(anchor_to_anchor(i,:));
end
dis_table=Inf(all_nodes.anchors_n,all_nodes.nodes_n);  
obtained_hopsize_table=zeros(all_nodes.nodes_n,1);     
for i=all_nodes.anchors_n+1:all_nodes.nodes_n
    obtained_hopsize=hopsize(find(shortest_path(i,1:all_nodes.anchors_n)==min(shortest_path(i,1:all_nodes.anchors_n))));        
    obtained_hopsize_table(i,:)=obtained_hopsize(1);   
    unknown_to_anchors_dist=transpose(obtained_hopsize(1)*shortest_path(i,1:all_nodes.anchors_n));
    dis_table(:,i)=unknown_to_anchors_dist;   
end
save 'dvhop1_result.mat' shortest_path hopsize obtained_hopsize_table dis_table;
end