function [Graph] = GenarateGraphParallel(const)
%生成不同并行度的拓扑（合成后的DAG）：生成DAG的逻辑是，生成合成后的DAG，然后调用GenarateCommon_2生成各用户DAG，
%然后再调用FulFillTaskGraph，给每个点和边权重值

%先生成合成之后的DAG，因此所有点都存在
%这个函数的输出，对于每个单独DAG，每个子任务类型都随机一下存在/不存在，得到多个用户的DAG即可
%只得到拓扑结构，Graph(i,i) = 1，Graph(i,j) = 1/-1表示这条边存在，Graph(i,j)=0表示没有这条边
%具体每个点和边的权重另外赋值
%const表示并行度，范围1~(Tasknum-2)，为1表示全部串行，为Tasknum-2表示出了收尾子任务外全部并行

%生成不同partition的拓扑图

Tasknum = ceil(1/const) + 2 ;
Graph = zeros(Tasknum,Tasknum);

Graph(1,1) = 10;
Graph(Tasknum,Tasknum) = 10;
Graph(Tasknum-1,Tasknum-1) = 10-(ceil(1/const)-1)*const*10;

for i = 2:Tasknum-2
    Graph(i,i) = const * 10; %合成的DAG中，所有任务都存在
end

st = 1;
en = Tasknum;
for i = 2:Tasknum-1
    Graph(st,i) = 1;
    Graph(i,st) = -1;
    Graph(i,en) = 1;
    Graph(en,i) = -1;
end


