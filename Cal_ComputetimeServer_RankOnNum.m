function [rs] = Cal_ComputetimeServer_RankOnNum(index,Tasknum,userNum,Servernum,Cache,ComputeSpeed_server,Possionrate_sum,Taskgraph)
%����rank�Ĺ����У������index��������ڱ�����ı�Ե�������ϵļ���ʱ�䡣ע�����������ٶ��Ƿ���������ٶ� / ��̨�������������������

%��̨�����������˵�index������
serverindex = -1;
for i=1:Servernum
    if (Cache(index,i) == 1)
        serverindex = i;
        break;
    end
end

%��һ����̨�����������˼�������
count = 0;
for i=1:Tasknum
    if Cache(i,serverindex) == 1
        count = count + 1;
    end
end

r = ComputeSpeed_server(serverindex);%��̨���������������ٶ�
r = r/count;
B = -1;
for i=1:userNum
    if(Taskgraph(index,index,i) ~= 0)
        B = Taskgraph(index,index,i);%����index�ļ�����
        break;
    end
end

rs = 1/(r/B - Possionrate_sum(index));
     
end

