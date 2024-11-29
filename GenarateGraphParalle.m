function [Graph] = GenarateGraphParalle(Tasknum,const)
%���ɲ�ͬ���жȵ����ˣ��ϳɺ��DAG��������DAG���߼��ǣ����ɺϳɺ��DAG��Ȼ�����GenarateCommon_2���ɸ��û�DAG��
%   Ȼ���ٵ���FulFillTaskGraph����ÿ����ͱ�Ȩ��ֵ

%�����ɺϳ�֮���DAG��������е㶼����
%������������������ÿ������DAG��ÿ�����������Ͷ����һ�´���/�����ڣ��õ�����û���DAG����

%ֻ�õ����˽ṹ��Graph(i,i) = 1��Graph(i,j) = 1/-1��ʾ�����ߴ��ڣ�Graph(i,j)=0��ʾû��������
%����ÿ����ͱߵ�Ȩ�����⸳ֵ

%const��ʾ���жȣ���Χ1~(Tasknum-2)��Ϊ1��ʾȫ�����У�ΪTasknum-2��ʾ������β��������ȫ������

Graph = zeros(Tasknum,Tasknum);
for i = 1:Tasknum
    Graph(i,i) = 1; %�ϳɵ�DAG�У��������񶼴���
end

parameter = Tasknum - 2 - const; % ǰ��tasknum - 1 - const�������� 
for i =1:parameter
    Graph(i,i + 1) = 1;
    Graph(i+1,i) = -1;
end

parameter = parameter + 1;
for i = (parameter + 1) : (Tasknum - 1) %�ⲿ������ȫ������
    Graph(parameter,i) = 1;
    Graph(i,parameter) = -1;
    Graph(i,Tasknum) = 1;
    Graph(Tasknum,i) = -1;
end

    
    
end

