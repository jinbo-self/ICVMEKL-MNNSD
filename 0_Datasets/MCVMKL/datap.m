

c = [year;year1;year4];
class = 200;

label = c(:,end);
label(label==0)=2;
c =c(:,1:end-1);

c =[c,label];

[cow,~]=size(c);

a=[];

Polish.data = {};
for j=1:class
    a(j)=0;
for i =1:cow
    
    if c(i,end)==j
        a(j) = a(j)+1;
        Polish.data{j}(a(j),:)=c(i,1:end-1);
    end
end
end