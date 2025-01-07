function [Res, t_train] = REKM_MSE_MultiClass(trainSet , testSet , inPutInf)
    %返回训练时间t_train和训练集和测试集的精度以及标签
    totalClass = size(trainSet , 2) ; 
    tstLabel = testSet(:, end);
    testSet(:, end) = [];
    trainData = [];
    for i = 1 : totalClass
        tmp = trainSet{i};
        tmp(:, end+1) = i;
       trainData = [trainData; tmp]; 
    end
    inPutInf.class = totalClass;
    trnLabel = trainData(:, end);
    lenTrn = length(trnLabel);
    trainData(:, end) = [];
    T = zeros(lenTrn, totalClass);
    labels = diag(ones(totalClass, 1));
    for i = 1 : totalClass
       ind = find(trnLabel == i);
       T(ind, :) = repmat(labels(i,:), length(ind), 1); 
    end
     tic;
    [empTrn, empTst] = GenerateEmpiricalData([trainData,trnLabel] , testSet , inPutInf);
    Res = MSE_Fuc(empTrn, T, [empTst, tstLabel]);
     t_train = toc;

end

function Res = MSE_Fuc(train, T, test)
    [lenTst, dim] = size(test);
    tstLabel = test(:, end);
    test(:, end) = [];
    [a, trnLabel] = max(T');
    trnLabel = trnLabel';    
    
    W = pinv(train)*T;
    
    trn_out = train* W;
    [a, trn_predict] = max(trn_out');
    trn_predict = trn_predict';
    trnReg = length(find(trn_predict == trnLabel))/length(trnLabel);
    
    tst_out = test* W;    
    [a, tst_predict] = max(tst_out') ;
    tst_predict = tst_predict' ;    
    tstReg = length(find(tst_predict == tstLabel))/lenTst ;
    
    Res.trn_Class = trn_predict;
    Res.trnReg = trnReg;    
    Res.tst_Class = tst_predict ;
    Res.tstReg = tstReg ;
end

function [empTrn, empTst] = GenerateEmpiricalData(trainData , testSet , inPutInf)
    M = inPutInf.M ;
    sampleRate = inPutInf.sampleRate;
    
    len = size(trainData, 1);
    
    empTrn = [] ;
    empTst = [] ;
    kernelType = char(inPutInf.kType) ;        %如果换成固定样本投影而非随机样本投影呢？？
    tempKPar = inPutInf.kPar ;
    for i = 1 : M               %3个子集，每个子集p个数据，核的个数也为M
       
        tmpTrn = sampleRate;
        L = get_H(trainData,inPutInf.class);
        tmpTrn(:,end)=[];
        
        kPar = tempKPar(i) ;   
        [emp_train , emp_test] = kernel_mapping(tmpTrn, trainData , testSet , kernelType , kPar,L) ; 
        %tmpTrn为训练样本中的p个数，输出经验训练集和测试集
        empTrn = [empTrn, emp_train] ; 
        empTst = [empTst, emp_test] ;
    end
end