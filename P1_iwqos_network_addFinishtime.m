function [preCache,preTaskComputationSpeed,preFinishTime,curUserFinishTime] = P1_iwqos_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%��P1_iwqos_network�����Ƕ���һ�����ز���Finishtime����һ��1*userNum�ľ��󣬱�ʾÿ���û�DAG��������ʱ��
%�ú�����2021.7.25Ϊ�˼�ʵ�飺����Ϊĳ��ʱ������ɵ�������������P2_network_addFinishtime�������ʹ��

%��Copy_of_P1_iwqos�Ļ����ϣ����Ӳ���Transferrate_network�����ҵ���P2_network
    %���Ƿ���������ͨ��

%iwqos��ƪ���µĻ��������ֱ�Ӹ���̰�ĵõ��ģ�����Ҫ����
%�õ�������Ժ�ֱ�Ӵ���P2_RankOnNum���õ�������Դ������Ժ�����ƽ�������ӳ�


%�ϳɵ�DAG��ÿ���������������յĲ��ɵ��������
Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end


%���շ������ļ����ٶ�����
ServerSpeed = zeros(Servernum,2);
for i=1:Servernum
    ServerSpeed(i,1) = ComputeSpeed_server(i);
    ServerSpeed(i,2) = i;
end


%���򣬿��Ż�����д������������ð�ݰɣ�ע���ٶ���������ǰ��
for i=1:Servernum
    for j = 1:Servernum - i
        if(ServerSpeed(j,1) < ServerSpeed(j+1,1) )
            temp = ServerSpeed(j,1:2);
            ServerSpeed(j,1:2) = ServerSpeed(j+1,1:2);
            ServerSpeed(j+1,1:2) = temp;             
        end
    end
end

ServerSpeedRank = ServerSpeed(:,2);

preCache = zeros(Tasknum,Servernum);
Cached = zeros(1,Tasknum);
ServerMemoryRemain = ServerMemory;


%�����һ��ȡ�����˳��
taskset = randperm(Tasknum,Tasknum);

for k = 1:Servernum
    serverIndex = ServerSpeedRank(k);
    for i=1:Tasknum
        taskId = taskset(i);
        if (Cached(taskId) == 0) %������û����
            if ServerMemoryRemain(serverIndex) >= TaskMemory(taskId)
                ServerMemoryRemain(serverIndex) = ServerMemoryRemain(serverIndex) - TaskMemory(taskId);
                preCache(taskId,serverIndex) = 1;
                Cached(taskId) = 1;
            end
        end
        
    end
end

% for k = 1:Servernum
%     serverIndex = ServerSpeedRank(k);
%     for i=1:Tasknum
%         if (Cached(i) == 0) %������û����
%             if ServerMemoryRemain(serverIndex) >= TaskMemory(i)
%                 ServerMemoryRemain(serverIndex) = ServerMemoryRemain(serverIndex) - TaskMemory(i);
%                 preCache(i,serverIndex) = 1;
%                 Cached(i) = 1;
%             end
%         end
%         
%     end
% end


% for k = 1:Servernum
%     serverIndex = ServerSpeedRank(k);
%     for i=1:Tasknum
%         if (Cached(i) == 0) %������û����
%             if ServerMemoryRemain(serverIndex) >= TaskMemory(i)
%                 ServerMemoryRemain(serverIndex) = ServerMemoryRemain(serverIndex) - TaskMemory(i);
%                 preCache(i,serverIndex) = 1;
%                 Cached(i) = 1;
%             end
%         end
%         
%     end
% end

%��preCache����P2_RankOnNum
[preTaskComputationSpeed,preFinishTime, curUserFinishTime] = P2_network_addFinishtime(Tasknum,userNum,Servernum,preCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);


end

