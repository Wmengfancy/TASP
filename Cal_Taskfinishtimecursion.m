function [rs] = Cal_Taskfinishtimecursion(Tasknum_cur,Tasknum,index)
%Cal_Taskfinishtime��������øú���
%�ݹ�����index�������ʵ�����ʱ�䣬�����ں���Rankrecursion
MAX = 0;
for j=1:Tasknum
    if(index == j)
        continue;
    end
    if(Tasknum_cur(j,j) == 0)
        continue;
    end
    if(Tasknum_cur(index,j) == 0)
        continue;
    end
    
    if(Tasknum_cur(index,j) < 0) %����j������i��ǰ������
        temp = Cal_Taskfinishtimecursion(Tasknum_cur,Tasknum,j) + Tasknum_cur(j,index); %Tasknum_cur(j,index)��������
        if(MAX < temp)
            MAX = temp;
        end
    end
end

rs = Tasknum_cur(index,index) + MAX;
    
end

