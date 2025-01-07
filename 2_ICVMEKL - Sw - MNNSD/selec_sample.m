
function res = selec_sample(tra,line_num,max_re)
%tra格式为{X1,X2,X3...}，每个元胞内为一个类的数据
res = [];
len = length(tra);
for i=1:len
    t = [];
    if i==1
        for j=2:len
            t = [t;tra{j}];
        end
    elseif i==length(tra)
        for j=1:len-1
            t = [t;tra{j}];
        end
    else
        for j=1:i-1
            t = [t;tra{j}];
        end
        for j=i+1:len
            t = [t;tra{j}];
        end
    end
    
    result =less_sample(tra{i},t,line_num,max_re);
    if length(result)==1
        res = 1;
        break
    end
    res = [res;result];
end
end

function result = less_sample(X1,X2,line_num,max_re)
  %考虑到一对多的问题，这里只是对X1进行选择，并且只返回X1选择的部分样本,X2与X1一同选择，但不返回
  %一次循环返回一个类的样本选择，有几个类就进行几次循环
    class = [X1(:,end);X2(:,end)];
    
    X = [X1(:,1:end-1);X2(:,1:end-1)];
    [x1_rowdata,~]=size(X1);
    [x2_rowdata,~]=size(X2);
    tra_num = x1_rowdata+x2_rowdata;
    cA = sum(X1(:,1:end-1))/x1_rowdata;
    cB = sum(X2(:,1:end-1))/x2_rowdata;
   
    AB = sqrt(sum((cA-cB).^2));     

    each_line = AB/line_num;      %划分区域
    each_re = zeros(1,line_num);
    each_re_num=zeros(1,line_num);   %记录每个区域样本数量
    each_re_data = {};        %记录每个区域的样本
    for i=1:line_num
        each_re_data{i}=zeros(size([X,class]));
    end
    X = [X,class];
    dis_X = zeros(1,size(X,1));

    for j=1:tra_num
        dis_Xi1 = get_dist(cA,cB,X(j,1:end-1)); 
        dis_Xi2 = get_dist(cB,cA,X(j,1:end-1));
        
        if dis_Xi1<0 || dis_Xi2<0          %砍掉质心A左边的数据和B的数据,保留A和A交B的数据
            dis_X(j) = 0;
        else
            dis_X(j) = dis_Xi1;
        end
   
        for i=1:line_num
            if ((i-1)*each_line < dis_X(j))&& (dis_X(j)<=i*each_line)         
                    if X(j,end)~=X1(1,end)                        
                        each_re(i)=each_re(i)+1;
                    end 
                    each_re_num(i)=each_re_num(i)+1;
                    each_re_data{i}(j,:)=[X(j,1:end-1),class(j)];
            end      
        end
    end
    for i=1:line_num
           each_re_data{i}(all( each_re_data{i}  == 0,2),:) = [];
    end
   
    each_re_num(find(each_re_num==0))=1; %如果each_re_num=0,那么each_re一定等于0，考虑到除数不能为0，所以置为1
%     each_re = abs(each_re);
    each_re = each_re./each_re_num;
   res=[];
   res(1)=each_re(1);
   for i=2:length(each_re_data)
       res(i)=each_re(i)-each_re(i-1);
   end

   %删除噪声
   result = [];
   for i=1:length(each_re_data)
       if res(i)>max_re
           tmp_re = i;
           break
       end
   end
   if res(tmp_re)==1
       tmp_re = tmp_re-1;
   end
   for i=tmp_re:length(each_re_data)
       result = [result;each_re_data{i}];
   end
   result = result( find( result(:,end)==X1(1,end) ) , : );
end

function dis = get_dist(cA,cB,xi)
%m1和m2是质心,m3到m1m2的投影距离m1的距离
a = cB-cA;
b = xi-cA;
dis = a*(dot(a,b)/dot(a,a));%其实就是b*cos
dis = sqrt(dis*dis');
if sum(a.*b)/(a*a'*b*b')<0
    dis = -dis;
end
end


