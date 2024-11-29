function [ServerMemory,Possionrate,ComputeSpeed_server,Transferrate,Transferrate_network] = GenerateData_ServerNetworkConnect(edgeNum,userNum,Servernum,Tasknum)
%与GenarateData函数相比，多了第一个输入值edgeNum，表示服务器之间边的数量
%多一个输出Transferrate_network，表示服务器之间的连通情况
%一开始没考虑服务器之间的连通情况，直接默认所有服务器互相都连通，只是通信速度不一样

%生成Taskgraph后，随机生成各种数据，包括各点和边的权重、任务（消耗）和服务器内存、服务其间传输速度、各DAG泊松参数、本地和服务器计算速度
%EdgeWeight和TaskSize这两个参数，用于改变Taskgraph中各点和边的权重（现在Taskgraph只表示了拓扑，各任务和边存在则是1/-1）

cacheRation = 0.5;%把能够被缓存的任务比例控制在cacheRatio附近

low = round(20 * Tasknum * cacheRation/Servernum + 25);
high =  round(80 * Tasknum * cacheRation/Servernum + 25);
ServerMemory = randi([low high],1,Servernum);%每个边缘服务器的内存大小
ServerMemory = ServerMemory * 4;

%服务器间通信速度 (4,6) 。这样通信时间范围[0.33, 2]，均值为1
%2021/01/15，修改为(1,4)，通信时间范围[0.5,8]，均值2（没改）

%Transferrate = 4 + 2*rand(Servernum+userNum,Servernum+userNum); %这应该是个对称矩阵
Transferrate = rand(Servernum+userNum,Servernum+userNum); %这应该是个对称矩阵
for i=2:(Servernum+userNum)
    for j = 1:(i-1)
        Transferrate(i,j) = Transferrate(j,i);
    end
end

Transferrate_network = Transferrate;

%----------------添加代码，网络连通性（边缘服务器之间有的能连通，有的不能连通，一共edgeNum条边）---------------------------------------
NetworkTopo = zeros(Servernum, Servernum);

n = Servernum;
rowLast = zeros(1,n - 1);
rowLast(1) = n-1;
for i=2:(n - 1)
    rowLast(i) = rowLast(i-1) + n-i;
end

MAX_EDGE_NUM = n * (n - 1)/2;
%右上半部分（不包含中间斜线）共n*(n-1)/2个点，第一行点数(n-1)，第n-1行点数1。分别编号为1 ~ n*(n-1)/2
edgeset = randperm(MAX_EDGE_NUM,edgeNum); %从1~n * (n - 1)/2中，随机选出edgeNum个数

for index = 1:edgeNum
    %分别找到edgeset(index)代表所在行和列下标，在这里添加一条边
    row = 1;
    while edgeset(index) > rowLast(row)
        row = row + 1;
    end

    %第row行共有Tasknum - row个点
    col = n - (rowLast(row) - edgeset(index));

    NetworkTopo(row, col) = 1;
    NetworkTopo(col, row) = 1;
end

for i=1:Servernum
    for j=1:Servernum
        if i==j
            continue;
        end

        if NetworkTopo(i,j) == 0
            Transferrate_network(i,j) = Transferrate_network(i,j) * NetworkTopo(i,j); %NetworkTopo(i,j)为1，这两个服务器才连通，为0的话不连通
        end

    end
end
%--------------------------------------------------------------------------------------------

%λ范围(0.01, 0.05);
Possionrate = 0.01 + 0.04*rand(1,userNum); 

%每个边缘服务器的计算速度  
%2121/01/15，把ComputationSpeedRatio从10提升到20
ComputationSpeedRatio = 20; %在服务器执行的任务，在经过速度分配后，分配到的速度对应的μ是本地执行的多少倍
%Tasknum * cacheRation/Servernum平均每个服务器上有几个任务瓜分速度
low = round(3 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio);
high = round(5 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio);
ComputeSpeed_server = randi([low high],1,Servernum);
ComputeSpeed_server = ComputeSpeed_server/5;
end