function [preCache,preTaskComputationSpeed,preFinishTime] = P1_RankOnNum(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server)
%P1_RankOnNum + P2_RankOnNum �������P1 + P2����ɾ����

%��㺯��P1�������������Cache����ΪP2���������P2
%ÿ������ı�һ��server�Ļ�����ԣ�ע���жϸı�֮���Ƿ�����ÿ������������౻����һ�Σ��Լ����������ڴ��С�Ƿ񳬳�����
%preCache������ߣ�preTaskComputationSpeed��Ե�����������������ļ������ʣ�preFinishTimeƽ��ÿ��DAG�����ʱ���Ȩƽ��
%
%P1�Ľ���������ʲô����ʱ�ǵ���100��

%ServerMemory(i)��ʾ��i����Ե���������ڴ��С
%TaskMemory(i)��ʾ�����i����������������ڴ��С  1*Tasknum

%�ϳɵ�DAG��ÿ���������������յĲ��ɵ��������
Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end

preCache = zeros(Tasknum,Servernum);%Tasknum*Servernum�ľ���Cache(i,j)==1/0��ʾserver j����/û��������i��һ��ʼ��ʼ��һ����������Ĳ���
%hasCached = zeros(1,Tasknum);%hasCached(i) =1��ʾ����i�Ѿ���������

%��ʼ���б�Ե���񶼲������κ�����Cache������Ԫ�ض�Ϊ0
%����P2���õ����ڵ������ӳ�
[preTaskComputationSpeed,preFinishTime] = P2_RankOnNum(Tasknum,userNum,Servernum,preCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);

bestCache = preCache;
bestTaskComputationSpeed = preTaskComputationSpeed;
bestFinishTime = preFinishTime;

w = 2;%������������ã���Ӱ�쵽��������Ƿ����׸ı�
Iterationnum = 500000;%������ʱ�Ե���10000����Ϊ�������������������Ƿ�Ӧ����ÿ�εõ���ʱ�䲨����С��
for iteration =1:Iterationnum
    changeIndex = randi(Servernum,1,1);%���ѡ��һ��������
    %�����������������ϵĻ������
    hasCached = HasCacheTasks(changeIndex,preCache,Tasknum,Servernum);%�������������Ѿ������������
    newCache = preCache;
    newCache(:,changeIndex) = RandomCachePolicy(changeIndex,hasCached,ServerMemory,TaskMemory,Tasknum);
    
    %���»�����Դ���P2���õ��µ��ӳٽ��
    [curTaskComputationSpeed,curFinishTime] = P2_RankOnNum(Tasknum,userNum,Servernum,newCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    
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

