
c = Heart1;
label = c(:,end);
c =c(:,1:end-1);
label(label(:,end)==0)=1;
label(label(:,end)~=1)=2;
c =[c,label];
% c = [c(:,2:end),c(:,1)];

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
b=0;
Heart.data = {};
Heart.data{1}=[];
Heart.data{2}=[];
% 
for i =1:cow
    if c(i,end)==1
        a = a+1;
        Heart.data{1}(a,:)=c(i,1:end-1);
    end
end
for i =1:cow
    if c(i,end)==2
        b = b+1;
        Heart.data{2}(b,:)=c(i,1:end-1);
    end
end