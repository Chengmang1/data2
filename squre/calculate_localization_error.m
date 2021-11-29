function [Localization_error,Unresolve_num]=calculate_localization_error()

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load('MAOA_result.mat')
    figure;
    hold on;
    box on;
    plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');%the anchors
    Unresolved_unknown_nodes_index=find(all_nodes.anc_flag==0);%the unresolved unknown nodes
    Unresolved_num=length(Unresolved_unknown_nodes_index);
    plot(all_nodes.true(Unresolved_unknown_nodes_index,1),all_nodes.true(Unresolved_unknown_nodes_index,2),'ko');
    resolved_unknown_nodes_index=find(all_nodes.anc_flag==2);%estimated locations of the resolved unkonwn nodes
    plot(all_nodes.estimated_MAOA(resolved_unknown_nodes_index,end-1),all_nodes.estimated_MAOA(resolved_unknown_nodes_index,end),'bo'); %
    plot(transpose([all_nodes.estimated_MAOA(resolved_unknown_nodes_index,end-1),all_nodes.true(resolved_unknown_nodes_index,1)]),...
        transpose([all_nodes.estimated_MAOA(resolved_unknown_nodes_index,end),all_nodes.true(resolved_unknown_nodes_index,2)]),'b-');
    axis auto;
    title('Localization error distribution diagram');    
    try 
        x=0:all_nodes.grid_L:all_nodes.square_L;
        set(gca,'XTick',x);
        set(gca,'XTickLabel',num2cell(x));
        set(gca,'YTick',x);
        set(gca,'YTickLabel',num2cell(x));
        grid on;
    catch
        %none
    end 
    xlabel('x-coordinate(m)')
    ylabel('y-coordinate(m)')
end