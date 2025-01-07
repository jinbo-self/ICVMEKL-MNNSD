function [emp_train , emp_Test] = kernel_mapping(tmpTrn, train_data , test_data , kernelPerType , kernelPar,L)
    %
    % train_data = {train_class_one , train_class_two } ;
    % test_data = [X_in_input_space ] ;
    %
    
    train_data(:,end)=[];
    [emp_train , emp_Test] = emp_Generator(tmpTrn, train_data , test_data , kernelPerType , kernelPar,L) ;    
end

function [emp_train, emp_Test] = emp_Generator(tmpTrn, trainData , testData , kType , kPar,L)
    % start clock for trainData
    %tmpTrn 是随机取的数据点
    implicitKernel = Kernel(tmpTrn , trainData , kType , kPar) ;%获得高斯核矩阵
    implicitKernel_Sw =  implicitKernel*L*implicitKernel';
    [pc , variances , explained] = pcacov(implicitKernel_Sw);%获得特征向量、特征值、每个特征值占比

    i = 1 ;
    label = 0 ;%标志位，等于1就是特征值有效
    while variances(i) >= 1e-3 
        if i+1 > size(variances,1) 
            label = 1 ;
            break ;
        end
        i = i + 1 ;    
    end
    
    if label == 0 
        i = i - 1 ;
    end

    index = 1 : i ;
    P = pc(: , index) ; %特征向量矩阵
    R = diag(variances(index)) ;%特征值对角矩阵
    
    
    implicitKernel = Kernel(trainData , tmpTrn , kType , kPar) ;
    emp_train = implicitKernel * P * R^(-1/2) ;    
    kerTestMat = Kernel(testData ,tmpTrn , kType , kPar) ;
    emp_Test = kerTestMat * P * R^(-1/2) ;  
end

