function [preCache,preTaskComputationSpeed,preFinishTime] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%��P3�Ļ����ϣ������˷���������ͨ�ԣ������������Transferrate_network


%��㺯��P1�������������Cache����ΪP2���������P2
%ÿ������ı�һ��server�Ļ�����ԣ�ע���жϸı�֮���Ƿ�����ÿ������������౻����һ�Σ��Լ����������ڴ��С�Ƿ񳬳�����
%preCache������ߣ�preTaskComputationSpeed��Ե�����������������ļ������ʣ�preFinishTimeƽ��ÿ��DAG�����ʱ���Ȩƽ��
%
%P1�Ľ���������ʲô����ʱ�ǵ���100��

%ServerMemory(i)��ʾ��i����Ե���������ڴ��С
%TaskMemory(i)��ʾ�����i����������������ڴ��С  1*Tasknum

Graph = zeros(Tasknum,Tasknum);
for k = 1:userNum
    for i=1:Tasknum
        for j=1:Tasknum
            if Taskgraph(i,j,k) ~= 0
                Graph(i,j) = Taskgraph(i,j,k);%�����û���dag���ϳɴ��dag
            end
        end
    end
end

%�ϳɵ�DAG��ÿ���������������յĲ��ɵ��������
Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end


%�ڹ�����Ѱ�����Ž⣬������Ϊ����ֵ
bestCache = zeros(Tasknum,Servernum);
bestTaskComputationSpeed = zeros(1,Tasknum);
bestFinishTime = 999999999;%��ʼ��Ϊһ���ܴ��ֵ

preCache = zeros(Tasknum,Servernum);
preTaskComputationSpeed = zeros(1,Tasknum);
preFinishTime = 999999999;

w = 1;%������������ã���Ӱ�쵽��������Ƿ����׸ı�
Iterationnum = 500;%������ʱ�Ե���10000����Ϊ�������������������Ƿ�Ӧ����ÿ�εõ���ʱ�䲨����С��
for iteration =1:Iterationnum
    
    newCache = zeros(1,Tasknum);%newCache(i)��ʾ����i�Ļ���λ�ã�Ϊ0��ʾû�б����档һ����Ҫת��ΪP2������Ҫ��cache��ʽ
    remainServerMemory = ServerMemory;%ÿ��������ʣ�µ��ڴ���Դ
    
    rudu = zeros(1,Tasknum);%��¼Graph��ÿ����������
    for i=1:Tasknum
        for j=1:Tasknum
            if Graph(i,j) < 0
                rudu(i) = rudu(i) + 1;
            end    
        end
    end
    
    Queue = zeros(1,0);%����һ�����У���ʼΪ�գ�����Ϊ0��
    for i=1:Tasknum
        if rudu(i) == 0
            Queue(end + 1) = i; %�����Ϊ0�ĵ������С���������൱�ڶ��е�offer()
        end
    end
    
    while ~isempty(Queue(:)) %��������һ�����������㷨�����Ϊ0������������
        tem_TaskId = Queue(1);%Queue.peek()
        Queue(1) = [];%Queue.poll()
        
        %�ҵ�tem_TaskId�����������ǰ�������У�ͨ�������������Ǹ�
        pre_TaskId = 0;
        maxEdge = 0;
        for i=1:Tasknum
            if i == tem_TaskId
                continue;
            end
            
            if Graph(i,tem_TaskId) > maxEdge
                maxEdge = Graph(i,tem_TaskId);
                pre_TaskId = i;
            end
        end
        
        if pre_TaskId == 0 %����tem_TaskIdû��ǰ�����������ѡ��һ��������
            availableServer = zeros(1,0);%��ͳ����Щ����������������TaskMemory(tem_TaskId)
            len = 0;
            for k = 1:Servernum
                if remainServerMemory(k) >= TaskMemory(tem_TaskId)
                    availableServer(end + 1) = k;
                    len = len + 1;
                end
            end
            
             changeIndex = randi([0,len],1,1); %ע��������0~len֮�䣬0��ʾ�����档���򻺴��ڷ�����availableServer(changeIndex)��
             if changeIndex~=0
                newCache(tem_TaskId) = availableServer(changeIndex); %ʣ���ڴ���Դ��ȥTaskMemory(tem_TaskId)
                remainServerMemory(availableServer(changeIndex)) = remainServerMemory(availableServer(changeIndex)) - TaskMemory(tem_TaskId);
             end
        else %����tem_TaskId��ǰ������,�ҵ���pre_TaskId������ķ����������߱��أ�ͨ���ٶ����ķ��������򱾵أ�
            %���������һ�������������߶��ڱ��أ����ٶ���죨ͨ��ʱ��Ϊ0��
            if newCache(pre_TaskId) == 0
                newCache(tem_TaskId) = 0;
            else %ǰ������pre_TaskId�ڱ�Ե������ִ��
                serverIndex = newCache(pre_TaskId);
                if remainServerMemory(serverIndex) >= TaskMemory(tem_TaskId)  %���ǰ���������ڷ��������ڴ滹�㹻�������������������
                    newCache(tem_TaskId) = serverIndex;
                    remainServerMemory(serverIndex) = remainServerMemory(serverIndex) - TaskMemory(tem_TaskId);
                else %���򣬴��ڴ���Դ�㹻�ķ������У��ҵ��������serverIndex֮��ͨ���ٶ����ķ��������п������з������ڴ涼�������Ǿͱ���ִ��
                    tempServerIndex = 0;
                    maxCommunicateSpeed = 0;
                    for k = 1:Servernum
                        %if remainServerMemory(k) >= TaskMemory(tem_TaskId) &&Transferrate(k, serverIndex) > maxCommunicateSpeed
                        if remainServerMemory(k) >= TaskMemory(tem_TaskId)
                            rate = Transferrate(k, serverIndex);
                            if Transferrate_network(k, serverIndex) == 0
                                rate = rate/2; %�����������������ͨ����ʱ�Ĵ���ʽ�ǰ���������������ͨ���ٶȳ���2������
                            end
                            if rate > maxCommunicateSpeed
                                maxCommunicateSpeed = rate;
                                tempServerIndex = k;
                            end
                           
                        end
                    end
                    
                    newCache(tem_TaskId) = tempServerIndex;
                    if tempServerIndex~= 0 %����˵��û�����������ı�Ե����������˱���ִ��
                        remainServerMemory(tempServerIndex) =  remainServerMemory(tempServerIndex) - TaskMemory(tem_TaskId);
                    end
                end
            end
            
        end
        
        %������tem_TaskId�����к����������-1���������Ϊ0���������Queue����
        for i=1:Tasknum
            if i == tem_TaskId
                continue;
            end
            
            if Graph(tem_TaskId, i) > 0
                rudu(i) = rudu(i) - 1;
                if rudu(i) == 0
                     Queue(end + 1) = i;
                end
            end
        end
        
    end
    
    %��newCacheת��ΪP2������Ҫ��cache������ʽ��������������������������
    newCache_temp = zeros(Tasknum,Servernum);
    for i = 1:Tasknum
        if newCache(i) ~= 0
            newCache_temp(i, newCache(i)) = 1;
        end
    end
    
    newCache = newCache_temp;
    
    %���»�����Դ���P2���õ��µ��ӳٽ��
    [curTaskComputationSpeed,curFinishTime] = P2_network(Tasknum,userNum,Servernum,newCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
     if curFinishTime < bestFinishTime
        bestFinishTime = curFinishTime;
        bestCache = newCache;
        bestTaskComputationSpeed = curTaskComputationSpeed;
     end
    
    %�����¾ɻ�����Եõ����ӳٽ�����ж�Ҫ��Ҫ���»������
    probaility = 1/(1 + exp((curFinishTime-preFinishTime)/w));
    temp = [0,1];%��probaility�ĸ���ȡ��0����ʾ���»�����ߣ���1-probaility����ȡ��1��ʾ������
    prob = [probaility,1-probaility];
    update = randsrc(1,1,[temp;prob]);
    if(update == 0)
        preTaskComputationSpeed = curTaskComputationSpeed;
        preFinishTime = curFinishTime;
        preCache = newCache;
    end
    
end

preCache = bestCache;
preTaskComputationSpeed = bestTaskComputationSpeed;
preFinishTime = bestFinishTime;

end

