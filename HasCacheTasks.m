function [hasCached] = HasCacheTasks(index,Cache,Tasknum,Servernum)
%���˱�Ե������index�����������������������Щ����
%����һ��1*Tasknum�ľ���hasCached(i) == 1��ʾ����i�Ѿ�����index����������ķ���������

hasCached = zeros(1,Tasknum);

for j=1:Servernum
    for i=1:Tasknum
        if(j == index)
            continue;
        end
        
        if(Cache(i,j) == 1)
            hasCached(i)=1;
        end
    end
end
            

end

