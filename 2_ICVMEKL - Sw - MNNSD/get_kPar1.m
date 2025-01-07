function kPar = get_kPar(data)
[row,~] = size(data);
k = 0;
for i=1:row
    for j=1:row
        tmp1 = data(i,:) - data(j,:);
        tmp2 = sqrt(sum(tmp1.*tmp1));
        k  = k + tmp2;
    end
end

kPar = k/(row*row);
end