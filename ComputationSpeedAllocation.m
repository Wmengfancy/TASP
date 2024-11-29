function [rs] = ComputationSpeedAllocation(rank_combine,Cache,Cachelocation,Cachestatus,Tasknum,Servernum,ComputeSpeed_server)
%����rank_combineֵ����������Cachestatus == 2������ļ�����Դ����Ӧ�������ϵļ����ٶȣ�

%ͳ��ÿ����Ե�������ϣ����������rankֵ֮��
Serverranksum = zeros(1,Servernum);
for j=1:Servernum
    for i=1:Tasknum
        if(Cache(i,j) == 1) %������j����������i
            Serverranksum(j) = Serverranksum(j) + rank_combine(i);
        end
    end
end

rs = zeros(1,Tasknum);% rs(i)��ʾ��i�������ڷ�������ִ�е��ٶ�
for i=1:Tasknum
    if(Cachestatus(i) == 0)
        rs(i) = 0;%����i�ڱ��ؼ��㣬��ֵ0
    elseif(Cachestatus(i) == 1) %����i��������Դ�������ٶ��Ƕ�Ӧ������������������
        rs(i) = ComputeSpeed_server(Cachelocation(i));
    else %������Դ����
        serverIndex = Cachelocation(i);
        rs(i) = ComputeSpeed_server(serverIndex) * (rank_combine(i)/Serverranksum(serverIndex));
    end
end

end

