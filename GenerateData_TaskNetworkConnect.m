function [EdgeWeight,TaskSize,TaskMemory,Computespeed_Local] = GenerateData_TaskNetworkConnect(const,userNum,Tasknum)
%��GenarateData������ȣ����˵�һ������ֵedgeNum����ʾ������֮��ߵ�����
%��һ�����Transferrate_network����ʾ������֮�����ͨ���
%һ��ʼû���Ƿ�����֮�����ͨ�����ֱ��Ĭ�����з��������඼��ͨ��ֻ��ͨ���ٶȲ�һ��

%����Taskgraph��������ɸ������ݣ���������ͱߵ�Ȩ�ء��������ģ��ͷ������ڴ桢������䴫���ٶȡ���DAG���ɲ��������غͷ����������ٶ�
%EdgeWeight��TaskSize���������������ڸı�Taskgraph�и���ͱߵ�Ȩ�أ�����Taskgraphֻ��ʾ�����ˣ�������ͱߴ�������1/-1��

%randi([20 80],1,Tasknum);%ÿ���������������ڴ��С��[20,80]���� GB
TaskMemory = zeros(1,Tasknum);
TaskMemory(1) = randi([100 400]);
TaskMemory(Tasknum) = randi([100 400]);

Memory = randi([100 400]);
for i = 2:Tasknum-2
    TaskMemory(i) = Memory*const;
end
TaskMemory(Tasknum-1) = Memory*(1-const*(Tasknum-3));

%�����ͨ�������ߵ�Ȩ�أ� [2,8]
EdgeWeight = zeros(Tasknum,Tasknum);
for i = 1:(Tasknum-1)
    for j=(i+1):Tasknum
        %EdgeWeight(i,j) = randi([16 32]); %�ĳ�[4,16]
        EdgeWeight(i,j) = randi([80 160]); %�ĳ�[4,16]
    end
end
%ÿ����������ļ����������Ȩ�أ� [10,30]  M CPU cycles
TaskSize = zeros(1,Tasknum);
TaskSize(1) = randi([50 150]);
TaskSize(Tasknum) = randi([50 150]);

%randi([20 80],1,Tasknum);%ÿ���������������ڴ��С��[20,80]���� GB

Size = randi([50 150]);
for i = 2:Tasknum-2
    TaskSize(i) = Size*const;
end
TaskSize(Tasknum-1) = Size*(1-const*(Tasknum-3));

%TaskSize =  randi([10 30],1,Tasknum);

% for k=1:userNum
%     for i=1:Tasknum
%         if Taskgraph(i,i,k) == 1
%             Taskgraph(i,i,k) = TaskSize(i);
%         end
%     end
% end

%���ؼ����ٶȣ� (3,5)   ���ؼ���ʱ��� ���Ȩ�ء����ؼ����ٶȡ���DAG���ɲ��� �йء�  ע�� ��>��
%ϣ������ִ�л���ʱ���ͨ��ʱ��Ҫ����������Ȼȫ������ִ����죬û��Ҫж��
Computespeed_Local = 1 + 2 * rand(Tasknum,userNum);  %��ʱ���ؼ���Ħ̷�Χ�� (0.1, 0.5)

end

