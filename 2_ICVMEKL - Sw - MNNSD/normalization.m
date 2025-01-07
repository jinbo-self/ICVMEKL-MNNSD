function result = normalization(data)
[row,col]=size(data);
result = zeros(row,col);
for i=1:row
    for j=1:col
        if max(data(:,j))~=min(data(:,j))
            result(i,j) = (data(i,j)-min(data(:,j)))/(max(data(:,j))-min(data(:,j)));
        else
            result(i,j)  = data(i,j);
        end
    end
end