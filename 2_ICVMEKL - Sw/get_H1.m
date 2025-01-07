function L = get_H(empTrn,totalClass)

labels = empTrn(:,end);
empTrn  = empTrn(:,1:end-1);
length_label = length(labels);
class_num = zeros(1,totalClass);
for i=1:totalClass
    class_num(i) = sum(labels==i);
end
W = zeros(length_label);
for k=1:totalClass
for i=1:length_label
    for j=1:length_label
        if labels(i)==labels(j)&&labels(j)==k
            W(i,j)=1/class_num(k);
        end
    end
end
end

D = zeros(length_label);
for i=1:length_label
    D(i,i)=sum(W(i,:));
end

L = D-W;


end
