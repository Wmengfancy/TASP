function [TaskComputationSpeed,AvgFinishtime,Finishtime] = P2_network_addFinishtime(Tasknum,userNum,Servernum,Cache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%�ú�����P2_network��Ψһ�����ǣ�����һ�����ز���Finishtime����һ��1*userNum�ľ��󣬱�ʾÿ���û�DAG��������ʱ�䡣
%�ú�����2021.7.25Ϊ�˼�ʵ�飺����Ϊĳ��ʱ������ɵ�������������P3_network_addFinishtime�������ʹ��

%����㻺����Թ̶����ڲ���������Դ�ķ��䣬�����ڲ㺯��P2
%����ÿ���������ܹ������ﴦ���Ѿ�ȷ���ˣ��е�����ֻ���ڱ���ִ�У��е��������ڱ��ػ���Ψһ�������ı�Ե������ִ��
%�������˵�����һ���ڱ�Ե������ִ�У�û�����������һ���ڱ���ִ�У�Ҫ��Ҫ���ñ����������Ҳ�����ڱ���ִ�У���
%��ô����ÿ�������ִ��λ�ö�ȷ����
%���ĳ̨������ֻ������һ������ķ�����ô�������������ٶȾ�����������������ٶ�
%���һ�������������˶��������ô�⼸������ʹ��ڼ�����Դ�ľ�����ϵ
%��������������ٶ��������rankֵ��Ȼ����rankֵ�ı�ֵ�����ּ�����Դ�������ٶȣ�
%���ֱ𼸸�DAG�����һ�������EFT�����˵ı�ֵ�õ�����ʱ����

%Tasknum��ʾ�ϳ�DAG��һ��������������
%Cache��ʾ�����������һ��Tasknum*Servernum�ľ���Cache(i,j)==1/0��ʾserver j����/û��������i
%Possionrate(i)��ʾ��i��DAG���û����Ĳ��ɷֲ���ֵ  1*userNum
%Possionrate_sum(i)��ʾ��i������������ܲ��ɷֲ���ֵ
%Taskgraph(:,:,i)��ʾ��i���û�DAG�Ĺ�������
%Transferrate��ʾ������֮��Ĵ������ʣ�
%   ��һ��(serverNum + userNum) * (serverNum + userNum)����serverNum + 1��ʾ��һ���û��ı����豸
%Computespeed_Local���ش�������ÿ������ļ������� Tasknum * userNum
%   Computespeed_Local(i,j)��ʾ��j������CPU�Ե�i������Ĵ����ٶ�
%ComputeSpeed_serverÿ����Ե�������������ٶ� ComputeSpeed_server(i)

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

%����ÿ������Ĵ���ʱ�䣬�õ��µ�DAG����Ȩ�ظı䣩��Ȼ������DAG��rankֵ
Taskgraph_finally = zeros(Tasknum, Tasknum);%�����µ�DAG Taskgraph_finally���������Ǻϳ�֮���DAG 
for k=1:userNum
    for i=1:Tasknum
        for j=1:Tasknum
            if(i == j)
                continue;
            end
            
            if(Taskgraph_finally(i,j) ~= 0)
                continue;
            end
            
            if(Taskgraph(i,j ,k) == 0)
                continue;
            end
            
            Taskgraph_finally(i,j) = Taskgraph(i,j,k);  
        end
    end
end
%�ѱߵ�Ȩ�ر��ͨ��ʱ��
%Cal_Communicationtime
Taskgraph_finally = Cal_Communicationtime_network(Taskgraph_finally,Transferrate,Transferrate_network,Cachelocation,Tasknum,userNum,Servernum,Taskgraph,Possionrate,Possionrate_sum); %����ߵ�Ȩ�أ�ͨ��ʱ�䣩���ߵ������� / ������������ͨ�����ʡ����ڱ���ִ�е�����ͨ��ʱ����Ҫ�����Ȩƽ��

for i=1:Tasknum%����A(i,i)�����Ȩ��
    if Cachestatus(i) == 0 %����iû�����棬�ڱ���ִ�С���������i�Ĵ���ʱ�䣨���ڸ�������CPU�ϴ���ʱ��ļ�Ȩƽ��ֵ��
        %DAG���Ȩ�أ�A��i,i�����������������Ĵ���ʱ��
        Taskgraph_finally(i,i) = Cal_ComputetimeLocal(i,userNum,Possionrate,Possionrate_sum,Computespeed_Local,Taskgraph);
    else
        Taskgraph_finally(i,i) = Cal_ComputetimeServer_RankOnNum(i,Tasknum,userNum,Servernum,Cache,ComputeSpeed_server,Possionrate_sum,Taskgraph);
    end
end

%���µ�DAG������ÿ�������rank��ע����Ҫ��ÿ��DAG�м���һ��rankֵ��Ȼ�����Ȩƽ��
rank = zeros(Tasknum,userNum);
for i=1:userNum
    %ʹ��Taskgraph(:,:,i)�����ˣ���ʹ��Taskgraph_finally�ĵ��Ȩ����ߵ�Ȩ��
    tempTaskgraph = Origintopo_NewWeight(Taskgraph(:,:,i),Taskgraph_finally,Tasknum);
    rank(:,i) = Rankup(tempTaskgraph,Tasknum);
end

rank_combine = zeros(1,Tasknum);%��ÿ��DAG�м�����ĸ�����rankȡ��Ȩƽ�����õ�ÿ�������rankֵ
for j=1:userNum
    for i=1:Tasknum
       rank_combine(i) = rank_combine(i) + rank(i,j)* Possionrate(j)/Possionrate_total;
    end
end

%Cachestatus == 2����Щ���񣨴�����Դ���������񣩣���Ҫ����rank_combineֵ�������ֶ�Ӧ��Ե�������ϵļ����ٶ�
%TaskComputationSpeed(i)��ʾ��i�������ڷ�������ִ�е��ٶȡ��������i�ڱ���ִ�У���ôA(i) ==0
TaskComputationSpeed = ComputationSpeedAllocation(rank_combine,Cache,Cachelocation,Cachestatus,Tasknum,Servernum,ComputeSpeed_server); %ÿ���������͵ļ����ٶȡ� A(i) = 0�������ڱ���ִ��


%Cache��TaskComputationSpeed����Ҫ��Ľ������������Ժͼ�����Դ�������
%������Ҫ���ݻ�����Ժͼ�����Դ������ԣ��õ���ʱ��ÿ��DAGִ��ʱ��ļ�Ȩƽ��ֵ
%��Ҫ�ֱ�ȥ��ÿ��DAG��Ȼ���ÿ��DAG���ӳ����Ȩƽ��
%���ںܼ򵥣���Ϊ��������Ѿ���offload���Ը�ȷ���ˣ�ʹ�����ƻ���rankֵ�ĵݹ�д�������һ���������ʱ�������
%��¼һ��DAG��ÿ������Ľ���ʱ�䣬�����Ǹ���������DAG�ļ���ʱ��
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




