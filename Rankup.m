function [Rank] = Rankup(Taskgraph,Tasknum)
%����һ��DAG���������DAG�ĸ�����rankֵ
%���յ�rankֵ�Ƕ��DAG�еõ���rank�ļ�Ȩƽ�����������ֻ�����ĳ��DAG�и������rank

%Taskgraph��һ��Tasknum * Tasknum�ľ��������DAGû������i����ôTaskgraph(i,i) = 0

Rank = zeros(1, Tasknum);
for i=1:Tasknum
    if Taskgraph(i,i) == 0
        Rank(1,i) = 0; %�����ǰDAG��û������i����ô��rankֵΪ0
        continue;
    end
    
    Rank(1,i) = Rankrecursion(Taskgraph,Tasknum, i);
end
end

