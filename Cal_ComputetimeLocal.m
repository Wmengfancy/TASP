function [rs] =Cal_ComputetimeLocal(index,userNum,Possionrate,Possionrate_sum,Computespeed_Local,Taskgraph)
%����rank�Ĺ����У������index������ı��ش���ʱ�䡣��һ���ڸ�������CPU�ϴ���ʱ��ļ�Ȩƽ��ֵ

rs = 0;
for i=1:userNum %�ֱ������ÿ��DAG�е�ʱ��
    if(Taskgraph(index, index, i) == 0)
        continue;
    end
    
    r = Computespeed_Local(index,i); %��i������CPU�Ե�index������ı��ش����ٶ�
    B = Taskgraph(index,index,i); %��i��DAG�У���index�����������������ע�����а����������������DAG�У���index�����������������һ��
    time = 1/(r/B - Possionrate(i));
    
    rs = rs + (Possionrate(i)/Possionrate_sum(index)) * time;  %Possionrate(i)��i��DAG������index�Ĳ��ɲ���
end
    
end

