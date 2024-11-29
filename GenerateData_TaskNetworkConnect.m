function [EdgeWeight,TaskSize,TaskMemory,Computespeed_Local] = GenerateData_TaskNetworkConnect(const,userNum,Tasknum)
%与GenarateData函数相比，多了第一个输入值edgeNum，表示服务器之间边的数量
%多一个输出Transferrate_network，表示服务器之间的连通情况
%一开始没考虑服务器之间的连通情况，直接默认所有服务器互相都连通，只是通信速度不一样

%生成Taskgraph后，随机生成各种数据，包括各点和边的权重、任务（消耗）和服务器内存、服务其间传输速度、各DAG泊松参数、本地和服务器计算速度
%EdgeWeight和TaskSize这两个参数，用于改变Taskgraph中各点和边的权重（现在Taskgraph只表示了拓扑，各任务和边存在则是1/-1）

%randi([20 80],1,Tasknum);%每种类型任务所需内存大小，[20,80]整数 GB
TaskMemory = zeros(1,Tasknum);
TaskMemory(1) = randi([100 400]);
TaskMemory(Tasknum) = randi([100 400]);

Memory = randi([100 400]);
for i = 2:Tasknum-2
    TaskMemory(i) = Memory*const;
end
TaskMemory(Tasknum-1) = Memory*(1-const*(Tasknum-3));

%任务间通信量（边的权重） [2,8]
EdgeWeight = zeros(Tasknum,Tasknum);
for i = 1:(Tasknum-1)
    for j=(i+1):Tasknum
        %EdgeWeight(i,j) = randi([16 32]); %改成[4,16]
        EdgeWeight(i,j) = randi([80 160]); %改成[4,16]
    end
end
%每种类型任务的计算量（点的权重） [10,30]  M CPU cycles
TaskSize = zeros(1,Tasknum);
TaskSize(1) = randi([50 150]);
TaskSize(Tasknum) = randi([50 150]);

%randi([20 80],1,Tasknum);%每种类型任务所需内存大小，[20,80]整数 GB

Size = randi([50 150]);
for i = 2:Tasknum-2
    TaskSize(i) = Size*const;
end
TaskSize(Tasknum-1) = Size*(1-const*(Tasknum-3));

%TaskSize =  randi([10 30],1,Tasknum);

% for k=1:userNum
%     for i=1:Tasknum
%         if Taskgraph(i,i,k) == 1
%             Taskgraph(i,i,k) = TaskSize(i);
%         end
%     end
% end

%本地计算速度， (3,5)   本地计算时间和 点的权重、本地计算速度、各DAG泊松参数 有关。  注意 μ>λ
%希望本地执行花费时间比通信时间要长几倍，不然全部本地执行最快，没必要卸载
Computespeed_Local = 1 + 2 * rand(Tasknum,userNum);  %此时本地计算的μ范围是 (0.1, 0.5)

end

