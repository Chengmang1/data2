function f=fitness(x,y, A_node,d,neighboring_anchor_n)

    f_sum=0;
    for i=1:neighboring_anchor_n
        f1=sqrt(((sqrt((x-A_node(i,1)).^2+(y-A_node(i,2)).^2))-d(i)).^2);
        f_sum=f_sum+f1;
    end
    f=f_sum;
end