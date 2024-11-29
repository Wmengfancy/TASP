function [preCache,preTaskComputationSpeed,preFinishTime,preTaskFinishtime] = P1_infocom_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server)
%��P1_infocom_network�����Ƕ���һ�����ز���Finishtime����һ��1*userNum�ľ��󣬱�ʾÿ���û�DAG��������ʱ��
%�ú�����2021.7.25Ϊ�˼�ʵ�飺����Ϊĳ��ʱ������ɵ�������������P2_infocom_network_addFinishtime�������ʹ��

%��Copy_of_P1_infocom��ȣ������������Transferrate_network�����ҵ���P2_infocom_network

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

preCache = zeros(Tasknum,Servernum);%Tasknum*Servernum�ľ���Cache(i,j)==1/0��ʾserver j����/û��������i
%hasCached = zeros(1,Tasknum);%hasCached(i) =1��ʾ����i�Ѿ���������

%��ʼ���б�Ե���񶼲������κ�����Cache������Ԫ�ض�Ϊ0
%����P2���õ����ڵ������ӳ�
[preTaskComputationSpeed,preFinishTime, preTaskFinishtime] = P2_infocom_network_addFinishtime(Tasknum,userNum,Servernum,preCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);

w = 5;%���������ʱ����Ϊ0.1����Ӱ�쵽��������Ƿ�ı�
Iterationnum = 800;%������ʱ�Ե���100����Ϊ�������������������Ƿ�Ӧ����ÿ�εõ���ʱ�䲨����С��
for iteration =1:Iterationnum
    changeIndex = randi(Servernum,1,1);%���ѡ��һ��������
    %�����������������ϵĻ������
    hasCached = HasCacheTasks(changeIndex,preCache,Tasknum,Servernum);%�������������Ѿ������������
    newCache = preCache;
    newCache(:,changeIndex) = RandomCachePolicy(changeIndex,hasCached,ServerMemory,TaskMemory,Tasknum);
    
    %���»�����Դ���P2���õ��µ��ӳٽ��
    [curTaskComputationSpeed,curFinishTime, curTaskFinishtime] = P2_infocom_network_addFinishtime(Tasknum,userNum,Servernum,newCache,Possionrate,Possionrate_sum,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    
    %�����¾ɻ�����Եõ����ӳٽ�����ж�Ҫ��Ҫ���»������
    probaility = 1/(1 + exp((curFinishTime-preFinishTime)/w));
    temp = [0,1];%��probaility�ĸ���ȡ��0����ʾ���»�����ߣ���1-probaility����ȡ��1��ʾ������
    prob = [probaility,1-probaility];
    update = randsrc(1,1,[temp;prob]);
    if(update == 0)
        preTaskComputationSpeed = curTaskComputationSpeed;
        preFinishTime = curFinishTime;
        preCache = newCache;
        preTaskFinishtime = curTaskFinishtime;
    end
    
end

end

