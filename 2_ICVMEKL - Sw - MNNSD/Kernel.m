function mat_kernel = Kernel(mat_train , mat_test , kernelType , kPara)
    % input parameters:
    % mat_train--－the train data, a row represents a sample       Xi
    % mat_test---- the test data, a row represents a sample        Xj
    % kernelType-- the kernel type
    % kPara------- the kernel parameter(s)
    % output parameter:
    % mat_kernel-- the kernel matrix
    %这里输入的mat_Test还是mat_train
    % Written by WangZhe on 2004-09-27. 
    lenOne = size(mat_train , 1) ;
    lenTwo = size(mat_test , 1) ;
    temp_mat = [] ;
    
    
    
    switch lower(kernelType)
        case 'linear'
            mat_kernel=mat_train*mat_test';
        case 'poly'
            temp_mat_kernel=(mat_train*mat_test'+1).^kPara;
            mat_kernel=temp_mat_kernel;
    %         D=diag(1./sqrt(diag(temp_mat_kernel)));
    %         mat_kernel=D*temp_mat_kernel*D;       
        case 'rbf'
            TrainSampleNum=size(mat_train,1);
            TestSampleNum=size(mat_test,1);
            mat_temp=sum(mat_train.^2,2)*ones(1,TestSampleNum)...%列项相加求和，扩展为方阵*2-2*Xi^2  Xi^2+Xj^2-2XiXj
                    +ones(TrainSampleNum,1)*sum(mat_test.^2,2)'...%59*1*1*59
                    -2*mat_train*mat_test';
            mat_kernel=exp(-mat_temp/(2*kPara^2));
        case 'sigmoid'
            mat_kernel=tan(kPara(1)*mat_train*mat_test'+kPara(2));        
        case 'exp'
            mat_kernel=(1+exp(kPara*mat_train*mat_test')).^(-1);
           
        
  %      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%   非参数核    %%%%%%%%%%%%%%%%%%%%%%%%%%%     
  %      
        case 'k10'
            for oneId = 1 : lenOne
                for twoId = 1 : lenTwo
                    temp_mat(oneId , twoId) = norm(mat_train(oneId , :) - mat_test(twoId , :)) ;
                end
            end
            z = max(temp_mat(:)) ;
            temp_mat = -temp_mat./z ;
            for i = 2 : 3
                temp_mat = temp_mat + temp_mat.^i./2^(i-1) ;
            end
            
            mat_kernel = 1 + temp_mat ;
            
        case 'k11'
            
            for oneId = 1 : lenOne
                for twoId = 1 : lenTwo
                    temp_mat(oneId , twoId) = norm(mat_train(oneId , :) - mat_test(twoId , :)) ;
                end
            end
            z = max(temp_mat(:)) ;
            temp_mat = -temp_mat./z ;
            for i = 2 : 3
                temp_mat = temp_mat + temp_mat.^i./i ;
            end
            
            mat_kernel = 1 + temp_mat ;
            

        case 'k12'
            
            for oneId = 1 : lenOne
                for twoId = 1 : lenTwo
                    temp_mat(oneId , twoId) = norm(mat_train(oneId , :) - mat_test(twoId , :)) ;
                end
            end
            z = max(temp_mat(:)) ;
            temp_mat = temp_mat./z ;
            mat_kernel = zeros(lenOne , lenTwo) ;
            
            for i = 1 : 3
                mat_kernel = mat_kernel + (-1)^i./((temp_mat).^i+1) ;
            end
            
            mat_kernel =  - mat_kernel ;         

        case 'k13'
            for oneId = 1 : lenOne
                for twoId = 1 : lenTwo
                    temp_mat(oneId , twoId) = norm(mat_train(oneId , :) - mat_test(twoId , :)) ;
                end
            end
            z = max(temp_mat(:)) ;
            temp_mat = temp_mat./z ;
            mat_kernel = 1 - sin(pi.*temp_mat./(2*z)) ;
  %      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%   非参数核    %%%%%%%%%%%%%%%%%%%%%%%%%%%     
  %
        otherwise 
            mat_kernel=mat_train*mat_test';
    end
end