function [Rank] = Rankrecursion(Taskgraph,Tasknum, i)
%�ݹ����ĳ�������rankֵ

MAX = 0;
for j=1:Tasknum
    if i == j
        continue;
    end
    if Taskgraph(j,j) == 0
        continue;
    end
    if Taskgraph(i,j) == 0
        continue;
    end
    
    if Taskgraph(i,j) > 0 % >0��ʾi��j�ıߣ�<0��ʾj��i�ı�
        temp = Rankrecursion(Taskgraph,Tasknum,j) + Taskgraph(i,j);
        if (MAX < temp)
            MAX = temp;
        end
    end
end

Rank = Taskgraph(i,i) + MAX;
end

