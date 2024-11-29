
function AvgFinishtime = Cal_Enumeration_Finishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%Cal_Enumeration_Finishtime

Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end
Cache = zeros(Tasknum,Servernum);%Tasknum*Servernum的矩阵，Cache(i,j)==1/0表示server j缓存/没缓存任务i。一开始初始化一个都不缓存的策略

server_task = [
    0,0,0;
    1,0,0;
    0,1,0;
    0,0,1;
    ];

best_time =1000;

%穷举部署策略寻找最短延迟
for n_7=1:Servernum+1
    Cache(7,:)=server_task(n_7,:);
    t7_memory = find(Cache(7,:)~=0);
    if t7_memory ~= []
        SeverMemory(t7_memory) = SeverMemory(t7_memory) - TaskMemory(7);
    end
    for n_6=1:Servernum+1
        Cache(6,:)=server_task(n_6,:);
        t6_memory = find(Cache(6,:)~=0);
        if t6_memory ~= [ ]
            SeverMemory(t6_memory) = SeverMemory(t6_memory) - TaskMemory(6);
        end
        for n_5=1:Servernum+1
            Cache(5,:)=server_task(n_5,:);
            t5_memory = find(Cache(5,:)~=0);
            if t5_memory ~= [ ]
                SeverMemory(t5_memory) = SeverMemory(t5_memory) - TaskMemory(5);
            end
            for n_4=1:Servernum+1
                Cache(4,:)=server_task(n_4,:);
                t4_memory = find(Cache(4,:)~=0);
                if t4_memory ~= []
                    SeverMemory(t4_memory) = SeverMemory(t4_memory) - TaskMemory(4);
                end
                for n_3=1:Servernum+1
                    Cache(3,:)=server_task(n_3,:);
                    t3_memory = find(Cache(3,:)~=0);
                    if t3_memory ~= []
                        SeverMemory(t3_memory) = SeverMemory(t3_memory) - TaskMemory(3);
                    end                    
                    for n_2=1:Servernum+1
                        Cache(2,:)=server_task(n_2,:);
                        t2_memory = find(Cache(2,:)~=0);
                        if t2_memory ~= []
                            SeverMemory(t2_memory) = SeverMemory(t2_memory) - TaskMemory(2);
                        end
                        for n_1=1:Servernum+1
                             Cache(1,:)=server_task(n_1,:);
                             t1_memory = find(Cache(1,:)~=0);
                             if t1_memory ~= []
                                SeverMemory(t1_memory) = SeverMemory(t1_memory) - TaskMemory(1);
                             end
                             t_memory = find(ServerMemory < 0 );
                             if t_memory ~= []
                                 continue;
                             else
                                [~,curFinishTime] = P2_network(Tasknum,userNum,Servernum,Cache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
                                if(best_time > curFinishTime)
                                    best_time = curFinishTime;	                                 
                                end
                             end
                        end
                    end
                end
            end
        end
    end
end
AvgFinishtime = best_time;

