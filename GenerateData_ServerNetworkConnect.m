function [ServerMemory,Possionrate,ComputeSpeed_server,Transferrate,Transferrate_network] = GenerateData_ServerNetworkConnect(edgeNum,userNum,Servernum,Tasknum)
%��GenarateData������ȣ����˵�һ������ֵedgeNum����ʾ������֮��ߵ�����
%��һ�����Transferrate_network����ʾ������֮�����ͨ���
%һ��ʼû���Ƿ�����֮�����ͨ�����ֱ��Ĭ�����з��������඼��ͨ��ֻ��ͨ���ٶȲ�һ��

%����Taskgraph��������ɸ������ݣ���������ͱߵ�Ȩ�ء��������ģ��ͷ������ڴ桢������䴫���ٶȡ���DAG���ɲ��������غͷ����������ٶ�
%EdgeWeight��TaskSize���������������ڸı�Taskgraph�и���ͱߵ�Ȩ�أ�����Taskgraphֻ��ʾ�����ˣ�������ͱߴ�������1/-1��

cacheRation = 0.5;%���ܹ���������������������cacheRatio����

low = round(20 * Tasknum * cacheRation/Servernum + 25);
high =  round(80 * Tasknum * cacheRation/Servernum + 25);
ServerMemory = randi([low high],1,Servernum);%ÿ����Ե���������ڴ��С
ServerMemory = ServerMemory * 4;

%��������ͨ���ٶ� (4,6) ������ͨ��ʱ�䷶Χ[0.33, 2]����ֵΪ1
%2021/01/15���޸�Ϊ(1,4)��ͨ��ʱ�䷶Χ[0.5,8]����ֵ2��û�ģ�

%Transferrate = 4 + 2*rand(Servernum+userNum,Servernum+userNum); %��Ӧ���Ǹ��Գƾ���
Transferrate = rand(Servernum+userNum,Servernum+userNum); %��Ӧ���Ǹ��Գƾ���
for i=2:(Servernum+userNum)
    for j = 1:(i-1)
        Transferrate(i,j) = Transferrate(j,i);
    end
end

Transferrate_network = Transferrate;

%----------------��Ӵ��룬������ͨ�ԣ���Ե������֮���е�����ͨ���еĲ�����ͨ��һ��edgeNum���ߣ�---------------------------------------
NetworkTopo = zeros(Servernum, Servernum);

n = Servernum;
rowLast = zeros(1,n - 1);
rowLast(1) = n-1;
for i=2:(n - 1)
    rowLast(i) = rowLast(i-1) + n-i;
end

MAX_EDGE_NUM = n * (n - 1)/2;
%���ϰ벿�֣��������м�б�ߣ���n*(n-1)/2���㣬��һ�е���(n-1)����n-1�е���1���ֱ���Ϊ1 ~ n*(n-1)/2
edgeset = randperm(MAX_EDGE_NUM,edgeNum); %��1~n * (n - 1)/2�У����ѡ��edgeNum����

for index = 1:edgeNum
    %�ֱ��ҵ�edgeset(index)���������к����±꣬���������һ����
    row = 1;
    while edgeset(index) > rowLast(row)
        row = row + 1;
    end

    %��row�й���Tasknum - row����
    col = n - (rowLast(row) - edgeset(index));

    NetworkTopo(row, col) = 1;
    NetworkTopo(col, row) = 1;
end

for i=1:Servernum
    for j=1:Servernum
        if i==j
            continue;
        end

        if NetworkTopo(i,j) == 0
            Transferrate_network(i,j) = Transferrate_network(i,j) * NetworkTopo(i,j); %NetworkTopo(i,j)Ϊ1������������������ͨ��Ϊ0�Ļ�����ͨ
        end

    end
end
%--------------------------------------------------------------------------------------------

%�˷�Χ(0.01, 0.05);
Possionrate = 0.01 + 0.04*rand(1,userNum); 

%ÿ����Ե�������ļ����ٶ�  
%2121/01/15����ComputationSpeedRatio��10������20
ComputationSpeedRatio = 20; %�ڷ�����ִ�е������ھ����ٶȷ���󣬷��䵽���ٶȶ�Ӧ�Ħ��Ǳ���ִ�еĶ��ٱ�
%Tasknum * cacheRation/Servernumƽ��ÿ�����������м�������Ϸ��ٶ�
low = round(3 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio);
high = round(5 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio);
ComputeSpeed_server = randi([low high],1,Servernum);
ComputeSpeed_server = ComputeSpeed_server/5;
end