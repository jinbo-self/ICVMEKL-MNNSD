
warning off ;               
clear;
clc;
data_name = "iono";
load('..\0_Datasets\MCVMKL\'+data_name+'.mat'); 
saveMatName = '.\report\' + data_name + '.mat';

%取20次均值存储结果,以及所有的中间结果和20次循环的结果，以及所有的参数
saveFileName = '.\report\' + data_name + '.txt'; %存取所有中间结果

dataSet = eval(data_name).data;
clc =1;    %取clc次平均精度和标准差
[row_data,col_data] = size(dataSet);
dataset = {};
k  = [];



for clc_index=1:clc
    data = [];  
    dataSet = eval(data_name).data;
for i=1:col_data
    
    dataSet{i} =[dataSet{i},i+zeros(size(dataSet{i},1),1)];
    length_data = size(dataSet{i},1);
    RandIndex = randperm( size( dataSet{i},1 ) ); 
    dataSet{i} = dataSet{i}( RandIndex,: ); 
    data = [data;dataSet{i}(:,1:end-1)];   
end

dataset{clc_index} = dataSet;
end

k1 = get_kPar(data);

fid=fopen(saveFileName,'w');
fclose(fid);

totalCycle = 2 ;        % 5倍交叉验证
totalClass = size(dataSet , 2) ;    % 数据集的总类 多少行
dim = size(dataSet{1} , 2) ;        % 输入样本的维度

M = 1 ;            % 生成的空间数
kType = 'rbf';     % 内核类型


kPar = [10^-2,10^-1,10^0,10^1,10^2];
%获取所有参数组合
tmp_kPar_num = 1;
tmp_kPar = {};

sampleRateSet = 1;  % P/N
 tic;
maxRes1 = [];
fprintf(' star\n ' ) ;
for clc_index=1:clc
    dataSet = dataset{clc_index};
    k = k1;
    segment = samples2Pieces(dataSet , totalCycle) ;    % 将样本随机分成5个子集
    saveFinalName = '.\tmp\' + data_name + '_final'+clc_index+'.txt'; %存取每次的结果
    fid=fopen(saveFinalName,'w');
    fclose(fid);

    C1 = 0;
for kPara1_dex=1:length(kPar)
    kPar1 = kPar(kPara1_dex)*k;
for kPara2_dex=1:1
    kPar2 = 0;
for kPara3_dex=1:1
    kPar3 = 0;
for RateId = 1 : length(sampleRateSet)
    sampleRate = sampleRateSet(RateId);
    inPutInf = turn_inPutInf(M,kType,C1,kPar1,kPar2,kPar3,sampleRate);
    saveRes = cell(totalCycle, 1);%循环每个p/n
    res = [];
    [res,saveRes] = get_res(totalCycle,segment,inPutInf,saveRes,res,totalClass,dim,saveFileName);  %五折交叉验证
    res(totalCycle+1 , :) = roundn( mean(res),-4) ;
    res(totalCycle+2 , :) = std(res(1:totalCycle , :)) ;
    res(totalCycle+3 , 1) = inPutInf.C;
    res(totalCycle+3 , 2) = inPutInf.kPar(1);
    res(totalCycle+4 , 1) = inPutInf.kPar(2);
    res(totalCycle+4 , 2) = inPutInf.kPar(3);
    res(totalCycle+5 , 1) = inPutInf.sampleRate;
 
    FinalSave = [res(totalCycle+1 , 1),res(totalCycle+2 , 1),res(totalCycle+1 , 2),res(totalCycle+2 , 2),res(totalCycle+3 , 1),res(totalCycle+3 , 2),res(totalCycle+4 , 1),res(totalCycle+4 , 2),res(totalCycle+5 , 1)];
    
    fid = fopen(saveFinalName,'a');
    fprintf(fid,'%f %f %f %f %f %f %f %f %f\n',FinalSave(1),FinalSave(2),FinalSave(3),FinalSave(4),FinalSave(5),FinalSave(6),FinalSave(7),FinalSave(8),FinalSave(9));
    fclose(fid);
    
    fid=fopen(saveFileName,'a');
    fprintf(fid,'%f %f %f %f %f %f %f %f %f\n',FinalSave(1),FinalSave(2),FinalSave(3),FinalSave(4),FinalSave(5),FinalSave(6),FinalSave(7),FinalSave(8),FinalSave(9));
    fprintf(".......\n clc_index = %f",clc_index);
    fprintf(' mean = %f    std = %f ' , res(totalCycle+1 , 1) , res(totalCycle+2 , 1)) ;
    fprintf(' meanTime = %f  tstd = %f       C=%f     para1=%f     para2=%f     para3=%f    p/n=%f\n.........\n' , res(totalCycle+1 , 2) , res(totalCycle+2 , 2), res(totalCycle+3 , 1), res(totalCycle+3 , 2),res(totalCycle+4 , 1),res(totalCycle+4 , 2),res(totalCycle+5 , 1)) ;
    fclose(fid);
end
end
end
end
end


mean_res = [];
for clc_index=1:clc
    tmp_file = '.\tmp\' + data_name + '_final'+clc_index+'.txt'; 
    x = importdata(tmp_file);
    delete(tmp_file);
    [~,index] = max(x(:,1));
    mean_res = [mean_res;x(index,:)];
end

maxRes = mean(mean_res(:,1));
std_maxRes = std(mean_res(:,1));

[tmp_max,tmp_index] = max(mean_res(:,1));

fprintf('.........\n Best = %f\t(std=%f)     ' ,mean_res(tmp_index,1) , mean_res(tmp_index,2)) ;
fprintf('Time = %f\t(std=%f) C=%f     para1=%f     para2=%f     para3=%f     p/n=%f\n..........\n' ,mean_res(tmp_index,3) , mean_res(tmp_index,4), mean_res(tmp_index,5), mean_res(tmp_index,6), mean_res(tmp_index,7), mean_res(tmp_index,8), mean_res(tmp_index,9)) ;
fprintf('.........\n Final_res = %f\t(std=%f)     ' ,maxRes , std_maxRes) ;

eve_res = importdata(saveFileName);
delete(saveFileName);

savedObj.eve_res = eve_res;
savedObj.Final_everyRes = mean_res;
savedObj.maxRes = [maxRes,std_maxRes];
savedObj.MaxPar = mean_res(tmp_index,:);
save(saveMatName, 'savedObj');


function parsave(fname,x)
save(fname,'x')
end




