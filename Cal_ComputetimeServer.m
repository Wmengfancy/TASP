function [rs] = Cal_ComputetimeServer(index,userNum,Servernum,Cache,ComputeSpeed_server,Possionrate_sum,Taskgraph)
%����rank�Ĺ����У������index��������ڱ�����ı�Ե�������ϵļ���ʱ�䡣ע���������Ա�Ե������������ٶ�����

%��̨�����������˵�index������
serverindex = -1;
for i=1:Servernum
    if (Cache(index,i) == 1)
        serverindex = i;
        break;
    end
end

r = ComputeSpeed_server(serverindex);%��̨���������������ٶ�
B = -1;
for i=1:userNum
    if(Taskgraph(index,index,i) ~= 0)
        B = Taskgraph(index,index,i);%����index�ļ�����
        break;
    end
end

rs = 1/(r/B - Possionrate_sum(index));
     
end

