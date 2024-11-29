function [rs] = RandomCachePolicy(index,hasCached,ServerMemory,TaskMemory,Tasknum)
%Ϊ��Ե������index���ѡ��һ�����������Ļ������

%hasCached(i) == 1��ʾ����i��������Ե������������
%ServerMemory(index)��ʾ�ñ�Ե���������ڴ��С
%TaskMemory(i)��ʾ�����i����������������ڴ��С

rs = zeros(1,Tasknum);
memorySize = ServerMemory(index);%ʣ���ڴ�����
hasVisited = hasCached;

count=0;%ͳ���Ѿ��������˵���������
for i=1:Tasknum
    if(hasCached(i) == 1)
        count = count+1;
    end
end

while count < Tasknum
    taskId =  randi(Tasknum,1,1);%���ѡ��һ������
    if(hasVisited(taskId) == 1) %ѡ���Ѿ����Թ������߱����������������˵����񣬾�continue
        continue;
    end
    
    flag = randi(2,1,1); %����һ��1~2�ľ��ȷֲ�����������Ϊ1����ʾ׼�����棬�����2���Ͳ�������
    if(flag == 1) %��Ҫ���棬���ǻ��ÿ����ڴ滹������
        if(memorySize >= TaskMemory(taskId))
            rs(taskId) = 1;
            memorySize = memorySize - TaskMemory(taskId);
        end 
    end
    
    %���ܻ������棬��taskId��������Ѿ����Թ���
    hasVisited(taskId) = 1;
    count = count + 1;
        
end


end

