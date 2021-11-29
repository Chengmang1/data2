% DE algorithm
function  [Convergence_curveDE] =DE(SearchAgents_no,Max_iter)

%DE(25,10)
clear,clc;
tic;
for kk=1:100
load details.mat
Max_iter=50;
SearchAgents_no=30;
F0=0.4;                            
CR=0.1;                   
v=zeros(SearchAgents_no,dim);                     
u=zeros(SearchAgents_no,dim);                      
x=rand(SearchAgents_no,dim)*(ub-lb)+lb;              
Convergence_curveDE=eye(1,Max_iter);
for m=1:SearchAgents_no
    Ob(m)=fobj(x(m,:));
end
trace(1)=min(Ob);    
for gen=1:Max_iter
    lamda=exp(1-Max_iter/(Max_iter+1-gen));
    F=F0*2^(lamda);
    for m=1:SearchAgents_no
        r1=randi([1,SearchAgents_no],1,1);
        while (r1==m)
            r1=randi([1,SearchAgents_no],1,1);
        end
        r2=randi([1,SearchAgents_no],1,1);
        while (r2==m)||(r2==r1)
            r2=randi([1,SearchAgents_no],1,1);
        end
        r3=randi([1,SearchAgents_no],1,1);
        while (r3==m)||(r3==r1)||(r3==r2)
            r3=randi([1,SearchAgents_no],1,1);
        end
        v(m,:)=x(r1,:)+F*(x(r2,:)-x(r3,:));
    end
    r=randi([1,dim],1,1);
    for n=1:dim
        cr=rand(1);
        if (cr<=CR)||(n==r)
            u(:,n)=v(:,n);
        else
            u(:,n)=x(:,n);
        end
    end
    for n=1:SearchAgents_no
        for m=1:dim
            if (u(n,m)<lb)||(u(n,m)>ub)
                u(n,m)=rand*(ub-lb)+lb;
            end
        end
    end
  
    for m=1:SearchAgents_no
        Ob1(m)=fobj(u(m,:));
    end
    for m=1:SearchAgents_no
        if Ob1(m)<Ob(m)
            x(m,:)=u(m,:);
            Ob(m)=Ob1(m);
        end
    end  
    for m=1:SearchAgents_no
        Ob(m)=fobj(x(m,:));
    end
    trace(gen)=min(Ob);
end
Convergence_curveDE=trace;
KKK(kk,:)=Convergence_curveDE;
end
abc=0;
Convergence_curveDE=zeros(1,Max_iter);
for i=1:Max_iter
    mmm(i)=sum(KKK(:,i));
    Convergence_curveDE(i)=mmm(i)/100;
for j=1:100
    ggg(j,i)=Convergence_curveDE(i)-KKK(j,i);
    abc=ggg(:,i)'*ggg(:,i); 
end
   Std_DE(i)=sqrt(1/100*abc);
end
save DE.mat KKK Convergence_curveDE Std_DE;
Convergence_curveDE(Max_iter)
Std_DE(Max_iter)
T_DE=toc