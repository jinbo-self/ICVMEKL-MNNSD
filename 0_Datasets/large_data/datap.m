
c = eb;
c = [c(:,1:2),c(:,4:end),c(:,3)];
% c = [c(:,2:end),c(:,1)];
totalclass = 20;
[cow,~]=size(c);

% c = [];
% for i=1:length(temp.textdata)
%     if cell2mat(temp.textdata(i,end))=='M'
%         c(i)=1;
%     else
%         c(i)=2;
%     end
% end
% temp.data = [temp.data,c'];
% [cow,~] = size(temp.data);
% c = temp.data;
a=0;

Electricity_Board .data = {};
for i=1:totalclass
    Electricity_Board .data{i}=[];
    a=0;
    for j =1:cow
        if c(j,end)==i
            a = a+1;
            Electricity_Board .data{i}(a,:)=c(j,1:end-1);
        end
end
end
% Electricity_Board .data{3}=[];
% 
