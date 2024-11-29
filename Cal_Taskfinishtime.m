function [EFT,Lastfinishtask] = Cal_Taskfinishtime(index,Cachelocation,TaskComputationSpeed,Taskgraph,Tasknum,Servernum,Possionrate,Possionrate_sum,Computespeed_Local,Transferrate)
%P2/P2_RankOnNum函数中，得到每个任务被服务器分配的计算速度之后，计算第i个用户DAG中每个任务的EFT，并返回最后完成的任务的EFT（整个DAG完成时间Lastfinishtask）

%对Tasknum的点和边的权重进行处理
%点的权重：如果任务是本地计算，则泊松是这个DAG的泊松参数Possionrate(index)，速度是这个本地CPU对任务taskId的速度Computespeed_Local(taskId,index)
%   如果任务是边缘服务器计算，则泊松是整个任务的泊松参数Possionrate_sum(taskId)，速度是分配好的速度TaskComputationSpeed(taskId)
%边的权重：如果Cachelocation计算的任务相同，则边的权重为0
%   如果一个在本地执行，一个在服务器执行，则通信速度是Transferrate(locationi,serverNum+index)
Tasknum_cur = Taskgraph(:,:,index);

%先处理点的权重
for i=1:Tasknum
    if(Tasknum_cur(i,i) == 0)
        continue;
    end
    
    if(Cachelocation(i) == 0)%任务i在本地执行
        Tasknum_cur(i,i) = 1/((Computespeed_Local(i,index)/Tasknum_cur(i,i)) - Possionrate(index));
    else %任务i在服务器上执行，速度从TaskComputationSpeed中获取
        Tasknum_cur(i,i) = 1/((TaskComputationSpeed(i)/Tasknum_cur(i,i)) - Possionrate_sum(i));      
    end    
end

%再处理边的权重
for i=1:(Tasknum-1)
    for j=(i+1):Tasknum
        if(Tasknum_cur(i,j) == 0)
            continue;
        end
        
        locai = Cachelocation(i);
        locaj = Cachelocation(j);
        if(locai == locaj)
            Tasknum_cur(i,j) = 0.0001; %当在同一个位置执行，通信时间不要设置为0，设置为一个很小的数
        elseif (locai == 0) %任务i在本地执行，任务j在边缘服务器执行
            Tasknum_cur(i,j) = Tasknum_cur(i,j)/Transferrate(Servernum + index,locaj);
        else
            Tasknum_cur(i,j) = Tasknum_cur(i,j)/Transferrate(locai,Servernum + index);
        end
    end
end
for i=2:Tasknum
    for j=1:(i-1)
        Tasknum_cur(i,j) = -Tasknum_cur(j,i);
    end
end
            

EFT = zeros(1,Tasknum);
Lastfinishtask = -1;
for i = 1:Tasknum
    if(Tasknum_cur(i,i) == 0)
        EFT(i) = -1;%如果当前DAG中没有这个任务，那么设置这个任务的完成时间是-1；
        continue;
    end
    
    EFT(i) = Cal_Taskfinishtimecursion(Tasknum_cur,Tasknum,i);
    if(EFT(i) > Lastfinishtask)
        Lastfinishtask = EFT(i);
    end
end
    
end

