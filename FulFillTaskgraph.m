function [Taskgraph] = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum)
%�����Taskgraphֻ��ʾ���ˣ���ͱߵ�Ȩ��Ϊ1/-1/0��
%EdgeWeight,TaskSize�Ǵ�GenerateData�����õ�������������������������Taskgraph�е�ͱߵ�Ȩ��

%Taskgraph�и��ߵ�Ȩ��
for k=1:userNum 
    for i = 1:(Tasknum - 1)
        for j = (i+1):Tasknum
            Taskgraph(i,j,k) = Taskgraph(i,j,k) * EdgeWeight(i,j);
        end
    end
    
    for i = 2:Tasknum
        for j = 1:(i-1)
            Taskgraph(i,j,k) = - Taskgraph(j,i,k);
        end
    end
end

%�ߵ�Ȩ��
for k=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,k) == 1
            Taskgraph(i,i,k) = TaskSize(i);
        end
    end
end

end

