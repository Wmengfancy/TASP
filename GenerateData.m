function [ServerMemory,TaskMemory,Possionrate,Transferrate,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData(userNum,Servernum,Tasknum)
%����Taskgraph��������ɸ������ݣ���������ͱߵ�Ȩ�ء��������ģ��ͷ������ڴ桢������䴫���ٶȡ���DAG���ɲ��������غͷ����������ٶ�
%EdgeWeight��TaskSize���������������ڸı�Taskgraph�и���ͱߵ�Ȩ�أ�����Taskgraphֻ��ʾ�����ˣ�������ͱߴ�������1/-1����
%   ��FulFillTaskGraph����������


cacheRation = 0.5;%���ܹ���������������������cacheRatio����
TaskMemory = randi([20 80],1,Tasknum);%ÿ���������������ڴ��С��[20,80]���� GB
low = round(20 * Tasknum * cacheRation/Servernum + 25);
high =  round(80 * Tasknum * cacheRation/Servernum + 25);
ServerMemory = randi([low high],1,Servernum);%ÿ����Ե���������ڴ��С




%�����ͨ�������ߵ�Ȩ�أ� [2,8]
EdgeWeight = zeros(Tasknum,Tasknum);
for i = 1:(Tasknum-1)
    for j=(i+1):Tasknum
        EdgeWeight(i,j) = randi([8 16]); %�ĳ�[4,16]
    end
end
% for k=1:userNum %Taskgraph�и��ߵ�Ȩ��
%     for i = 1:(Tasknum - 1)
%         for j = (i+1):Tasknum
%             Taskgraph(i,j,k) = Taskgraph(i,j,k) * EdgeWeight(i,j);
%         end
%     end
%     
%     for i = 2:Tasknum
%         for j = 1:(i-1)
%             Taskgraph(i,j,k) = - Taskgraph(j,i,k);
%         end
%     end
% end


%��������ͨ���ٶ� (4,6) ������ͨ��ʱ�䷶Χ[0.33, 2]����ֵΪ1
%2021/01/15���޸�Ϊ(1,4)��ͨ��ʱ�䷶Χ[0.5,8]����ֵ2��û�ģ�
Transferrate = 4 + 2*rand(Servernum+userNum,Servernum+userNum); %��Ӧ���Ǹ��Գƾ���
for i=2:(Servernum+userNum)
    for j = 1:(i-1)
        Transferrate(i,j) = Transferrate(j,i);
    end
end



%ÿ����������ļ����������Ȩ�أ� [10,30]  M CPU cycles
TaskSize =  randi([10 30],1,Tasknum);
% for k=1:userNum
%     for i=1:Tasknum
%         if Taskgraph(i,i,k) == 1
%             Taskgraph(i,i,k) = TaskSize(i);
%         end
%     end
% end

%���ؼ����ٶȣ� (3,5)   ���ؼ���ʱ��� ���Ȩ�ء����ؼ����ٶȡ���DAG���ɲ��� �йء�  ע�� ��>��
%ϣ������ִ�л���ʱ���ͨ��ʱ��Ҫ����������Ȼȫ������ִ����죬û��Ҫж��
Computespeed_Local = 3 + 2*rand(Tasknum,userNum);  %��ʱ���ؼ���Ħ̷�Χ�� (0.1, 0.5)
%�˷�Χ(0.01, 0.05);
Possionrate = 0.01 + 0.04*rand(1,userNum); 


%ÿ����Ե�������ļ����ٶ�  
%2121/01/15����ComputationSpeedRatio��10������20
ComputationSpeedRatio = 20; %�ڷ�����ִ�е������ھ����ٶȷ���󣬷��䵽���ٶȶ�Ӧ�Ħ��Ǳ���ִ�еĶ��ٱ�
%Tasknum * cacheRation/Servernumƽ��ÿ�����������м�������Ϸ��ٶ�
low = round(3 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio);
high = round(5 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio);
ComputeSpeed_server = randi([low high],1,Servernum);


end

