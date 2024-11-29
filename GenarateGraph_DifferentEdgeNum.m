function [Graph] = GenarateGraph_DifferentEdgeNum(Tasknum,edgeNum)
%���������ר��Ϊ DAG���Ӷȣ�DAG�бߵ���������������ֵ��ʵ��д��
%����һ������ΪTasknum������ΪedgeNum��DAG

%����Graph��edgeNum�Ǳߵ�����
%�ߵ��������Ϊ,n*(n-1)/2

Graph = zeros(Tasknum,Tasknum);
for i = 1:Tasknum
    Graph(i,i) = 1; %�ϳɵ�DAG�У��������񶼴���
end

rowLast = zeros(1,Tasknum - 1);
rowLast(1) = Tasknum-1;
for i=2:(Tasknum - 1)
    rowLast(i) = rowLast(i-1) + Tasknum-i;
end

MAX_EDGE_NUM = Tasknum * (Tasknum - 1)/2;
%���ϰ벿�֣��������м�б�ߣ���n*(n-1)/2���㣬��һ�е���(n-1)����n-1�е���1���ֱ���Ϊ1 ~ n*(n-1)/2
edgeset = randperm(MAX_EDGE_NUM,edgeNum); %��1~Tasknum * (Tasknum - 1)/2�У����ѡ��edgeNum����

for index = 1:edgeNum
    %�ֱ��ҵ�edgeset(index)���������к����±꣬���������һ����
    row = 1;
    while edgeset(index) > rowLast(row)
        row = row + 1;
    end
    
    %��row�й���Tasknum - row����
    col = Tasknum - (rowLast(row) - edgeset(index));
    
    Graph(row, col) = 1;
end


%�Գƾ��󣬴������½�
for i = 2:Tasknum
    for j=1:(i-1)
        Graph(i,j) = -Graph(j,i);
    end
end

end

