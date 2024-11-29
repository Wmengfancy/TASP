function [Taskgraph,Graph] = GenarateGraphCommon(Graph,Tasknum,userNum,commonration)
%��GenarateGraphCommon_2�����ˣ��ú������ò��鼯������ɵ�һ���û�DAG�д��ڶ����ͨ��֧�Ƕδ�����bug����ʱҪ����


%�õ���ͬ���Ƴ̶ȵ�userNum��DAG��DAG֮����ͬ������������ռ��������ע��userNum > 1���������빫��������������0�����򱨴�
%�����ȵ���GenarateGraphParalle�������õ��ϳ�֮���DAG�����ˣ�Ҳ��������������������Graph
%�����������֮���������Graph���ܻ�ı䣬����Ϊ�������
%�����������֮��Ӧ�ø�Taskgraph�и���͸��߸�ֵ

%��2021/1/11�������������㷨�и����⣺һЩ�û�DAG���ڶ���������
%��2021/1/11������˶��������񣬵��ǿ��ܴ���һЩDAG�д��ڶ����ͨ��֧������P2�������㲻��������
%(2021/1/19) ʹ�ò��鼯�����һ���û�DAG�п��ܴ��ڶ����ͨ��֧�����⣬����˺���findRoot()

%Graph�Ǻϳ�֮���DAG��������
%commonration�����ưٷֱ�

Taskgraph = zeros(Tasknum,Tasknum,userNum); 
ContainTaskNum = zeros(1,userNum);%ÿ��DAG�а�����������

commonnum = round(Tasknum * commonration);%��ͬ����������ĸ�������������
%��ǰTasknum-1��������������ظ�ѡ��commonnum-1��������Щ�������ٴ���������DAG��
tempCommontask = randperm(Tasknum - 1,commonnum-1);
%ʣ�µ�һ�����������ǵ�Tasknum����������������������DAG��
commontask = zeros(1,Tasknum);
commontask(1) = Tasknum;
commontask(2:commonnum) = tempCommontask(1:(commonnum-1));

for i=1:userNum
    Taskgraph(Tasknum,Tasknum,i) = 1;%����DAG�ж����ڵ�Tasknum������
end
ContainTaskNum(1:userNum) = 1;

for i=2:commonnum
    taskId = commontask(i);
    
    %����������DAG�������������������DAG�����һ����/û��
    selectedUser = randperm(userNum,2); %���ѡ�������û�DAG
    Taskgraph(taskId,taskId,selectedUser(1)) = 1;
    Taskgraph(taskId,taskId,selectedUser(2)) = 1;
    ContainTaskNum(selectedUser(1)) = ContainTaskNum(selectedUser(1)) + 1; %��ӦDAG��������������+1
    ContainTaskNum(selectedUser(2)) = ContainTaskNum(selectedUser(2)) + 1;
    
    for j = 1:userNum
        if Taskgraph(taskId,taskId,j) == 1
            continue;
        end
        
        isIn = randi(2,1,1); %���ѡ������1��2
        if isIn == 1
            Taskgraph(taskId,taskId,j) = 1;
            ContainTaskNum(j) =  ContainTaskNum(j) + 1;
        end
    end
end


%��������Tasknum - commonnum������ȡ1~userNum����������������ֻ�����������һ��DAG��
for i = 1:Tasknum
    %�������i�ǹ���������continue
    isContain = false;
    for j = 1:commonnum
        if commontask(j) == i
            isContain = true;
            break;
        end
    end
    if isContain == true 
        continue;
    end
    
    index = randi(userNum,1,1); %�����userNum��DAG��ѡ��һ��
    Taskgraph(i,i,index) = 1;
    ContainTaskNum(index) = ContainTaskNum(index) + 1;
end

%����ĳ��DAG��ֻ����һ������
% for i=1:userNum
%     if ContainTaskNum(i) == 0
%         %��Tasknum�������У����ѡ��1~��Tasknum�������и�������Ϊ��i��DAG����������
%         count =  randi(Tasknum,1,1);
%         tempTasks =  randperm(Tasknum,count);%1*count������
%         for k=1:count
%             tempTaskId = tempTasks(k);
%             Taskgraph(tempTaskId,tempTaskId,i) = 1;
%         end
%     end
% end


%��������DAG�зֱ�����Щ�����Ѿ�ȷ���ˣ�������ݷֱ��е����񣬸���
for k = 1:userNum
    for i = 1:Tasknum
        for j=1:Tasknum
            if(i == j)
                continue;
            end
            
            if Taskgraph(i,i,k)==1 && Taskgraph(j,j,k)==1 %��k��DAG�д�������i����������j�������߲Ż����
                Taskgraph(i,j,k) = Graph(i,j);
            end
        end
    end
end

%������ɵ�һЩ�û�DAG�д��ڶ��������������
for k = 1:userNum
    for i = 1:Tasknum
        if Taskgraph(i,i,k) == 0
            continue;
        end
        
        %�ж�����������ڵ�ǰDAG���ǲ��Ƕ���������
        flag = true;
        for j = 1:Tasknum
            if i == j
                continue;
            end
            
            if Taskgraph(i,j,k) ~= 0
                flag = false;
                break;
            end
        end
        
        if flag == true %������ֵ�ǰDAG�е��±�Ϊi�������Ƕ��������񣬾�Ҫ�ӱߣ�������ɷǶ���������
              pre = i - 1;
              next = i + 1;
              
              while pre >= 1 && Taskgraph(pre,pre,k)==0
                  pre = pre - 1;
              end
              if pre >= 1 %˵����ǰDAG�У�����i֮ǰ����Ÿ�С������
                  Taskgraph(pre,i,k) = 1;
                  Taskgraph(i,pre,k) = -1;
                  Graph(pre,i) = 1;%�ϳɵ�DAGҲ��Ҫ����������
                  Graph(i,pre) = -1;
              end
              
              while next <= Tasknum && Taskgraph(next,next,k)==0
                  next = next + 1;
              end
              if next <= Tasknum
                  Taskgraph(i,next,k) = 1;
                  Taskgraph(next,i,k) = -1;
                  Graph(i,next) = 1;
                  Graph(next,i) = -1;
              end
              
        end
        
    end
 
end

%���鼯�����ĳЩ�û�DAG�д���2����������ͨ��֧������
for k=1:userNum
    f = zeros(1,Tasknum);
    size = ones(1,Tasknum);
    
    for i=1:Tasknum
        if Taskgraph(i,i,k) == 1 %�����k���û�DAG��������i����ô��ʼ������i�ĸ��ڵ�Ϊ�����������������i����ô�丸�ڵ�Ϊ0�������Ͳ���������0��
            f(i) = i;
        end
    end
    
    for i=1:Tasknum
        for j=1:Tasknum
            if i==j
                continue;
            end
            
            if Taskgraph(i,j,k) > 0 %ֻ��>0�ı߲�������Ϊ����������ͼ
                %union(i,j)
                [rooti,f] = findRoot(f,i);
                [rootj,f] = findRoot(f,j);
                
                if rooti ~= rootj
                    f(rootj) = f(rooti);
                    size(rooti) = size(rooti) + size(rootj);
                end
            end
        end
    end
    
    [root,f] = findRoot(f,Tasknum); %ÿ��DAG�����ڵ�Tasknum������
    if size(root) == ContainTaskNum(k) %ֻ��һ����ͨ��֧
        continue;
    end
    
    %ͳ�Ƶ�k���û�DAG���м�����ͨ��֧����������ͨ��֧�ĸ��ڵ����rootset��
    rootset(1) = root;
    index = 1;
    for i=1:Tasknum
        if Taskgraph(i,i,k) == 0
            continue;
        end
        
        [curRoot,f] = findRoot(f,i);
        if ismember(curRoot,rootset) == 0 %���curRoot����rootset�����У������ rootset.add(curRoot)
            index = index + 1;
            rootset(index) = curRoot;
        end
    end
    
    %��rootset�е�һ��Ԫ�غ����һ��Ԫ�ؽ���λ�ã�rootset����������
    temp = rootset(1);
    rootset(1) = rootset(index);
    rootset(index) = temp;
    map = zeros(1,Tasknum); %ÿ����ͨ��֧�ĸ��ڵ���rootset�ж�Ӧ���±�λ�� 1~index
    for i=1:index
        map(rootset(i)) = i;
    end
    
    %�ҵ�ÿ����ͨ��֧���鼯���У��±������Ǹ�Ԫ��
    finalIndex = rootset;
    for i=1:Tasknum
        if Taskgraph(i,i,k) == 0
            continue;
        end
        
         [curRoot,f] = findRoot(f,i);
         if i > finalIndex(map(curRoot))
             finalIndex(map(curRoot)) = i;
         end
    end
    
    %��ӱߣ�����ͨ��ֻ֧��һ������һ����ͨ��֧������ĵ㣬������һ����ͨ��֧�ĸ��ڵ�
    for j = 2:index
        Taskgraph(finalIndex(j-1),rootset(j),k) = 1;
        Taskgraph(rootset(j),finalIndex(j-1),k) = -1;
        Graph(finalIndex(j-1),rootset(j)) = 1;
        Graph(rootset(j),finalIndex(j-1)) = -1;
    end
    
end

end


