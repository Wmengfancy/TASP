function [rs,f] = findRoot(f,i)
%���鼯��findRoot()����

% while f(i) ~= i
%     i = f(i);
% end
% 
% rs = i;

if f(i) ~= i
    [temp,f] = findRoot(f,f(i));
    f(i) = temp;
end

rs = f(i);
end

