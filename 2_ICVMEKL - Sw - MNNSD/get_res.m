function [res,saveRes] = get_res(totalCycle,segment,inPutInf,saveRes,res,totalClass,dim,saveFileName)
for index_cycle = 1:2 %循环每个交叉验证集类的元素 5*2  1dao5
        testSet = [] ;
        for i = 1 : totalClass     %1：2
            testSet = [testSet ; segment{index_cycle , i}] ;%11；12 第i个为测试集
        end
        trainSet = cell(1 , totalClass) ;
        for i = 1  : totalCycle   %
            if i ~= index_cycle %i!=1的所有集合为训练集
                for j = 1 : totalClass
                    trainSet{j} = [trainSet{j} ; segment{i , j}(:,1:dim-1)] ;
                end
            end
        end
        [trnRes, t_train] = REKM_MSE_MultiClass(trainSet , testSet , inPutInf) ; 
        %返回训练时间t_train和训练集和测试集的精度以及标签
        
        saveRes{index_cycle} = trnRes;
        res = [res ; [trnRes.tstReg, t_train]] ;
        fprintf('The %d cycle--- Recog: %f\n ' , index_cycle , trnRes.tstReg) ;
end
end