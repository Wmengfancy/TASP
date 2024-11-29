function [rs] = Cal_Communicationtime(Taskgraph_finally,Transferrate,Cachelocation,Tasknum,userNum,Servernum,Taskgraph,Possionrate,Possionrate_sum)
%����Taskgraph_finally(i,j)������i��j֮�䴫����������Ҫ��������i��j֮��ͨ��ʱ��
%ע���������i��j���ڱ���ִ�У�������ͬһ������ִ�У���ôͨ��ʱ����Ϊ0.0001����Ҫ����Ϊ0������Ϊû�������ߣ�

rs = Taskgraph_finally;

for i=1:(Tasknum-1)
    for j=(i+1):Tasknum
        if rs(i,j) == 0
            continue;
        end
        
        %���ж�����i������j����ķ����������
        locali = Cachelocation(i);
        localj = Cachelocation(j);
        
        if(locali == localj) %����������ڱ���ִ�У�������ͬһ����Ե������ִ�У���ôͨ��ʱ��Ϊ0
            rs(i,j) = 0.0001;
        elseif (locali ~= 0 && localj~=0) %���������ڲ�ͬ�ı�Ե��������ִ��
            rs(i,j) = rs(i,j)/Transferrate(locali,localj); %����֮��ͨ���� / �������������ͨ���ٶ�
        elseif locali == 0 %����i�ڱ���ִ�У�����j�ڱ�Ե��������ִ��
            temp = 0;
            for k=1:userNum
                if(Taskgraph(i,i,k) == 0)
                    continue;
                end
                
                temp = temp + (rs(i,j)/Transferrate(Servernum+k, localj)) * Possionrate(k)/Possionrate_sum(i);
            end
            rs(i,j) = temp;
        else % ����i�ڱ�Ե������ִ�У�����j�ڱ���ִ��
            temp = 0;
            for k=1:userNum
                if(Taskgraph(j,j,k) == 0)
                    continue;
                end
                
                temp = temp + (rs(i,j)/Transferrate(locali,Servernum+k)) * Possionrate(k)/Possionrate_sum(j);
            end
            rs(i,j) = temp;
        end
        
    end
end

for i=2:Tasknum
    for j=1:(i-1)
        rs(i,j) = -rs(j,i);
    end
end
                    
end

