function [rs] = Origintopo_NewWeight(Taskgraph,Taskgraph_finally,Tasknum)
%UNTITLED �˴���ʾ�йش˺�����ժҪ

rs = Taskgraph_finally;
for i=1:Tasknum
    for j=1:Tasknum
        if(Taskgraph(i,j) == 0)
            rs(i,j) = 0;
        end
    end
end

end

