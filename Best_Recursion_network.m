function [finishTime] = Best_Recursion_network(taskIndex,Cache,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,Possionrate_sum)
%Cache��ʾ�����������һ��Tasknum*Servernum�ľ���Cache(i,j)==1/0��ʾserver j����/û��������i
if taskIndex == Tasknum + 1
    [~,finishTime] = P2_network(Tasknum,userNum,Servernum,Cache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    return;
end


%taskIndex������
finishTime = Best_Recursion_network(taskIndex + 1,Cache,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,Possionrate_sum);

%taskIndex���γ��Ի��浽������1~Servernum
for serverIndex = 1 : Servernum
    if ServerMemory(serverIndex) < TaskMemory(taskIndex)
        continue;
    end
    
    Cache(taskIndex, serverIndex) = 1;
    ServerMemory(serverIndex) = ServerMemory(serverIndex) - TaskMemory(taskIndex);
    tempFinishTime = Best_Recursion_network(taskIndex + 1,Cache,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,Possionrate_sum);
    
    if tempFinishTime < finishTime
        finishTime = tempFinishTime;
    end
    
    %����
     Cache(taskIndex, serverIndex) = 0;
     ServerMemory(serverIndex) = ServerMemory(serverIndex) + TaskMemory(taskIndex);
    
end



