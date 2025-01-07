function Segment = samples2Pieces(dataSet , segmentNum) 
    %
    %dataSet is a structrue of {Class_1 , Class_2 , Class_3 , ...}
    %
    totalClass = size(dataSet , 2) ;
    Segment = [] ;
    for i = 1 : totalClass
        classData = dataSet{1,i} ;
        len = size(classData , 1) ;
        index = randperm(len) ;
        segSize = floor(len/segmentNum) ; %向下取整
        for k = 1 : segmentNum - 1
            Segment{i,k} = classData(index(segSize*(k-1) + 1 : segSize*k) , :) ;  %前4
        end
        Segment{i,k+1} = classData(index(segSize*(k) + 1 : len) , :) ;  %第五
    end
    Segment = Segment' ;
end