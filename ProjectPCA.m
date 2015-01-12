function Components = ProjectPCA(varargin)
%PROJECTPCA PCA done the hard way for the ICS-3000 project.
% Components = ProjectPCA(Data, args).
% arg component is an integer which determines which component will be
% plotted, default = 1 returns the one with the highest variance.
% 'plot' plots the selected component
%
% Loosely follows Smith, L 2002 A tutorial on Principal Components Analysis

if numel(varargin) == 0;
    Data = xlsread('train.xlsx');
    %Data = xlsread('independant.xlsx')
else
    Data = varargin{1};
end

%% Step 1 : Cleaning & normalization

x=2:2:size(Data,2);
Data(:,x) = []; 
%Removes all nonnumeric data from the data
%Data(isnan(Data))=[]; is buggy, results in one vector.
Data(1,:) = []; %Index row in excel data

numrows = size(Data,1);
numcolumns = size(Data,2);

DataMeans = mean(Data,2);
DataAdjusted = zeros(numrows, numcolumns);

x=1:numcolumns;
for i=1:numrows
    DataAdjusted(i,x)=Data(i,x)-DataMeans(i);
end

%% Step 2 : Creating the covariance matrix

S = cov(DataAdjusted);

%% Step 3 : Calculating the eigenvectors of the covariance matrix

[eigvectors, eigvalues] = eig(S);

% eigvectors is already a normalized feature matrix, with the columns being
% the right eigenvectors of S

eigvalues = diag(eigvalues); %Unravels the diagonal to a vector list

eigvalues = eigvalues(rindices);
eigvectors = eigvectors(:, rindices);

%% Step 4 : Deriving the new data set

Components = transpose(eigvectors)*transpose(DataAdjusted);

end

