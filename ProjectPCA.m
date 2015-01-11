function Components = ProjectPCA(Data)
%UNTITLED2 Summary of this function goes here

%Data = xlsread('train.xlsx')
%Data = xlsread('independant.xlsx')

x=2:2:size(Data,2);
Data(:,x) = []; 
%Removes all nonnumeric data from the data
%Data(isnan(Data))=[]; is buggy, results in one vector.

numcolumns = size(Data,1);
numrows = size(Data,2);

DataMeans = mean(Data);

DataAdjust = zeros(numrows, numcolumns);

for i=1:numrows
    for j=1:numcolumns
        DataAdjust(j,i)=Data(j,i)-DataMeans(i);
    end
end

end

