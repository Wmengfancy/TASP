function [EFT,Lastfinishtask] = Cal_Taskfinishtime(index,Cachelocation,TaskComputationSpeed,Taskgraph,Tasknum,Servernum,Possionrate,Possionrate_sum,Computespeed_Local,Transferrate)
%P2/P2_RankOnNum�����У��õ�ÿ�����񱻷���������ļ����ٶ�֮�󣬼����i���û�DAG��ÿ�������EFT�������������ɵ������EFT������DAG���ʱ��Lastfinishtask��

%��Tasknum�ĵ�ͱߵ�Ȩ�ؽ��д���
%���Ȩ�أ���������Ǳ��ؼ��㣬���������DAG�Ĳ��ɲ���Possionrate(index)���ٶ����������CPU������taskId���ٶ�Computespeed_Local(taskId,index)
%   ��������Ǳ�Ե���������㣬��������������Ĳ��ɲ���Possionrate_sum(taskId)���ٶ��Ƿ���õ��ٶ�TaskComputationSpeed(taskId)
%�ߵ�Ȩ�أ����Cachelocation�����������ͬ����ߵ�Ȩ��Ϊ0
%   ���һ���ڱ���ִ�У�һ���ڷ�����ִ�У���ͨ���ٶ���Transferrate(locationi,serverNum+index)
Tasknum_cur = Taskgraph(:,:,index);

%�ȴ�����Ȩ��
for i=1:Tasknum
    if(Tasknum_cur(i,i) == 0)
        continue;
    end
    
    if(Cachelocation(i) == 0)%����i�ڱ���ִ��
        Tasknum_cur(i,i) = 1/((Computespeed_Local(i,index)/Tasknum_cur(i,i)) - Possionrate(index));
    else %����i�ڷ�������ִ�У��ٶȴ�TaskComputationSpeed�л�ȡ
        Tasknum_cur(i,i) = 1/((TaskComputationSpeed(i)/Tasknum_cur(i,i)) - Possionrate_sum(i));      
    end    
end

%�ٴ���ߵ�Ȩ��
for i=1:(Tasknum-1)
    for j=(i+1):Tasknum
        if(Tasknum_cur(i,j) == 0)
            continue;
        end
        
        locai = Cachelocation(i);
        locaj = Cachelocation(j);
        if(locai == locaj)
            Tasknum_cur(i,j) = 0.0001; %����ͬһ��λ��ִ�У�ͨ��ʱ�䲻Ҫ����Ϊ0������Ϊһ����С����
        elseif (locai == 0) %����i�ڱ���ִ�У�����j�ڱ�Ե������ִ��
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
        EFT(i) = -1;%�����ǰDAG��û�����������ô���������������ʱ����-1��
        continue;
    end
    
    EFT(i) = Cal_Taskfinishtimecursion(Tasknum_cur,Tasknum,i);
    if(EFT(i) > Lastfinishtask)
        Lastfinishtask = EFT(i);
    end
end
    
end

