function [preCache,preTaskComputationSpeed,preFinishTime,preTaskFinishtime] = P1_infocom_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%与P1_infocom_network区别是多了一个返回参数Finishtime，是一个1*userNum的矩阵，表示每个用户DAG任务的完成时间
%该函数是2021.7.25为了加实验：纵轴为某个时间内完成的任务数量。与P2_infocom_network_addFinishtime函数配合使用

%与Copy_of_P1_infocom相比，多了输入参数Transferrate_network，并且调用P2_infocom_network

%外层函数P1，决定缓存策略Cache，作为P2的输入调用P2
%每次随机改变一个server的缓存策略，注意判断改变之后是否满足每种类型任务最多被缓存一次，以及服务器的内存大小是否超出限制
%preCache缓存决策，preTaskComputationSpeed边缘服务器分配给各任务的计算速率，preFinishTime平均每个DAG的完成时间加权平均
%
%P1的结束条件是什么？暂时是迭代100次

%ServerMemory(i)表示第i个边缘服务器的内存大小
%TaskMemory(i)表示缓存第i种类型任务所需的内存大小  1*Tasknum

%合成的DAG中每种类型子任务最终的泊松到达参数和
Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end

preCache = zeros(Tasknum,Servernum);%Tasknum*Servernum的矩阵，Cache(i,j)==1/0表示server j缓存/没缓存任务i
%hasCached = zeros(1,Tasknum);%hasCached(i) =1表示任务i已经被缓存了

%初始所有边缘服务都不缓存任何任务，Cache中所有元素都为0
%调用P2，得到现在的最终延迟
[preTaskComputationSpeed,preFinishTime, preTaskFinishtime] = P2_infocom_network_addFinishtime(Tasknum,userNum,Servernum,preCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);

w = 5;%这个参数暂时设置为0.1，会影响到缓存策略是否改变
Iterationnum = 800;%这里暂时以迭代100次作为结束条件。结束条件是否应该是每次得到的时间波动很小？
for iteration =1:Iterationnum
    changeIndex = randi(Servernum,1,1);%随机选中一个服务器
    %随机更新这个服务器上的缓存策略
    hasCached = HasCacheTasks(changeIndex,preCache,Tasknum,Servernum);%其他服务器上已经缓存任务情况
    newCache = preCache;
    newCache(:,changeIndex) = RandomCachePolicy(changeIndex,hasCached,ServerMemory,TaskMemory,Tasknum);
    
    %把新缓存策略带入P2，得到新的延迟结果
    [curTaskComputationSpeed,curFinishTime, curTaskFinishtime] = P2_infocom_network_addFinishtime(Tasknum,userNum,Servernum,newCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    
    %根据新旧缓存策略得到的延迟结果，判断要不要更新缓存策略
    probaility = 1/(1 + exp((curFinishTime-preFinishTime)/w));
    temp = [0,1];%以probaility的概率取到0，表示更新缓存决策，以1-probaility概率取到1表示不更新
    prob = [probaility,1-probaility];
    update = randsrc(1,1,[temp;prob]);
    if(update == 0)
        preTaskComputationSpeed = curTaskComputationSpeed;
        preFinishTime = curFinishTime;
        preCache = newCache;
        preTaskFinishtime = curTaskFinishtime;
    end
    
end

end

