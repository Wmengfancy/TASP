function [TaskComputationSpeed,AvgFinishtime,Finishtime] = P2_infocom_network_addFinishtime(Tasknum,userNum,Servernum,Cache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%�ú�����P2_infocom_network��Ψһ�����ǣ�����һ�����ز���Finishtime����һ��1*userNum�ľ��󣬱�ʾÿ���û�DAG��������ʱ�䡣
%�ú�����2021.7.25Ϊ�˼�ʵ�飺����Ϊĳ��ʱ������ɵ�������������P1_infocom_network_addFinishtime�������ʹ��

%����㻺����Թ̶����ڲ���������Դ�ķ��䣬�����ڲ㺯��
%���ڲ����Ǳߣ�ÿ�����񵥶�����
%2021/1/23���޸�rank�ļ��㷽ʽ����ֱ�ӴӺϳɵ�DAG�еõ��������Ƿֱ�������������ÿ���û�DAG�е�rank��Ȼ�����ɲ����ļ�Ȩƽ��

Possionrate_total = 0;%�����û��Ĳ��ɷֲ�����֮�ͣ�ע����Possionrate_sum����ÿ�����������ɲ���֮�� �ǲ�һ����
for i=1:userNum
    Possionrate_total = Possionrate_total + Possionrate(i);
end

Cachelocation = zeros(1,Tasknum);%Cachelocation(i)��ʾ����i�����浽��̨��������0��ʾû������
Cachestatus = zeros(1,Tasknum);%0��ʾû�����棬1��ʾû�м�����Դ������2��ʾ���ڼ�����Դ����
for j=1:Servernum
    count = 0; %��j̨��Ե�����������˼�����������
    for i=1:Tasknum
        if Cache(i,j) == 1
            count = count + 1;
        end
    end
    
    for i=1:Tasknum
        if Cache(i,j) == 1
            Cachelocation(i) = j;
            if count == 1
                Cachestatus(i) = 1;
            else
                Cachestatus(i) = 2;
            end
        end
    end
end

TaskTime = zeros(Tasknum);%���������ʱ��
for i=1:Tasknum
    if Cachestatus(i) == 0%����iû�����棬�ڱ���ִ��
        TaskTime(i) = Cal_ComputetimeLocal(i,userNum,Possionrate,Possionrate_sum,Computespeed_Local,Taskgraph);
    else %�ڷ������ϼ��㣬�������ڷ�����������ٶ���ִ��
        TaskTime(i) = Cal_ComputetimeServer(i,userNum,Servernum,Cache,ComputeSpeed_server,Possionrate_sum,Taskgraph);
    end
end

%����ֱ�ӴӺϳɵ�DAG�����еõ�ÿ�������rankֵ������Ҫ�ֱ�����������ÿ���û�DAG�е����ȼ���Ȼ����ݲ��ɷֲ�������Ȩ�صõ�����������rankֵ
%����ÿ�������rankֵ�����һ��������·�����ȣ������������ִ��ʱ��
rank_combine = zeros(1,Tasknum);
for i=1:Tasknum
    rank_combine(i) = TaskTime(i);
end

% rank = zeros(Tasknum,userNum);
% for k = 1:userNum
%     for i = 1:Tasknum
%         if Taskgraph(i,i,k) == 0
%             rank(i,k) = 0;
%         else %���ڲ����Ǳߣ����ȼ��������һ��������·�����ȣ������������ִ��ʱ��
%             rank(i,k) = TaskTime(i);
%         end
%     end
% end


% rank_combine = zeros(1,Tasknum);%��ÿ��DAG�м�����ĸ�����rankȡ��Ȩƽ�����õ�ÿ�������rankֵ
% for j=1:userNum
%     for i=1:Tasknum
%        rank_combine(i) = rank_combine(i) + rank(i,j)* Possionrate(j)/Possionrate_total;
%     end
% end

%�ڷ�����ִ�е����񱻷���ļ����ٶ�
TaskComputationSpeed = zeros(1,Tasknum);  %����ڱ��ؼ��㣬��ôTaskComputationSpeed(i) == 0�����Cachestatus(i) == 1����ô�ٶ������ڷ�������ȫ��

Serverranksum = zeros(1,Servernum);%ͳ��ÿ����Ե�������ϣ����������rankֵ֮��
for j=1:Servernum
    for i=1:Tasknum
        if(Cache(i,j) == 1) %������j����������i
            Serverranksum(j) = Serverranksum(j) + rank_combine(i);
        end
    end
end

for i=1:Tasknum
    if(Cachestatus(i) == 0)
        TaskComputationSpeed(i) = 0;
    elseif Cachestatus(i) == 1
        TaskComputationSpeed(i) = ComputeSpeed_server(Cachelocation(i));
    else 
        serverIndex = Cachelocation(i);
        TaskComputationSpeed(i) = ComputeSpeed_server(serverIndex) * (rank_combine(i)/Serverranksum(serverIndex));
    end
end

%�����ʲ��Ժͻ�����Զ�������֮��ʱ�仹�ǵð��մ��ڱߵ��������������ӳ�
Finishtime = zeros(1,userNum);
for i=1:userNum
    [EFT,Lastfinishtask] = Cal_Taskfinishtime_network(i,Cachelocation,TaskComputationSpeed,Taskgraph,Tasknum,Servernum,Possionrate,Possionrate_sum,Computespeed_Local,Transferrate,Transferrate_network);
    Finishtime(i) = Lastfinishtask;
end

%�����Ѿ��õ���ÿ��DAG�����ʱ�䣬���ղ��ɷֲ�������������Ȩƽ��
AvgFinishtime = 0;
for i=1:userNum
    AvgFinishtime = AvgFinishtime + Finishtime(i)*Possionrate(i)/Possionrate_total;
end

% %�ٴ���ÿ����������ļ���ʱ��
% for i=1:Tasknum
%     if Cachestatus(i) == 0 %����ڱ���ִ�У�����ʱ�����֮ǰ���������ʱ�� ����
%         continue;
%     else
%         B= -1;%����i�ļ�����
%         for k=1:userNum
%             if Taskgraph(i,i,k) ~= 0
%                 B = Taskgraph(i,i,k);
%                 break;
%             end
%         end
%         
%         TaskTime(i) = 1/((TaskComputationSpeed(i)/B) - Possionrate_sum(i));
%     end
% end
%     
% 
% Finishtime = zeros(1,userNum); %ÿ���û��������ʱ�䣬��������û��ļ������������У�����ʱ������Ǹ�
% for k = 1:userNum
%     for i = 1:Tasknum
%         if Taskgraph(i,i,k) ~= 0
%             if Finishtime(k) < TaskTime(i)
%                 Finishtime(k) = TaskTime(i);
%             end
%         end
%     end
% end
% 
% AvgFinishtime = 0;
% for i=1:userNum
%     AvgFinishtime = AvgFinishtime + Finishtime(i)*Possionrate(i)/Possionrate_total;
% end
          


end

