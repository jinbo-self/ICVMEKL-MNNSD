function [tra,tst] = data_process(data)
data_class = data(:,end);
data = data(:,1:end-1);
data = normalization(data);   %归一化,考虑到除不尽的情况，近似均值为0

data  =[data,data_class];

tra = [];
tst = [];
class1 = data(data(:,end)==1,:);
class2 = data(data(:,end)==-1,:);
temp1 = min(length(class1(:,1)),length(class2(:,1)));
tra_num = floor(temp1/2);
tra = [class1(1:tra_num,:);class2(1:tra_num,:)];
tst = [class1(tra_num+1:end,:);class2(tra_num:end,:)];
% tra = 
end