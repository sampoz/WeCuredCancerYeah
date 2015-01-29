function Components = ProjectPCA(varargin)
%PROJECTPCA PCA done the hard way for the ICS-3000 project.
% Components = ProjectPCA(Data, txtData, args).
% Data, txtData from xlsread('source.xlsx')
%
% Accepted arguments =
% any integer -> amount of principal components returned
% 'plot' -> plots the selected components 
% 'GPU' -> CUDA acceleration for the slow eig() -calls. Additional floating
% point errors!
%
% Loosely follows Smith, L 2002 A tutorial on Principal Components Analysis
% Done and tested with Matlab 2014b

if nargin == 0;
    [Data, txtData] = xlsread('train.xlsx');
    %Data = xlsread('independant.xlsx')
else
    Data = varargin{1};
    txtData = varargin{2};
end

numcomponents = size(Data,1)-1; % -1 from index row.

if nargin > 2;
    for i=1:nargin;
        if isnumeric(varargin{i})==1;
            numcomponents = varargin{i};
        end
    end
end


%% Step 1 : Cleaning & normalization

x=2:2:size(Data,2);
Data(:,x) = []; 
%Removes all nonnumeric data from the data
Data(isnan(Data))=[]; %is buggy, results in one vector.
Data(1,:) = []; %Index row in excel data

Data = transpose(Data); %Fixes the dimensions

numrows = size(Data,1);
numcolumns = size(Data,2);

x=1:2;
txtData = txtData(:,x); %Names for the variables
names = txtData(:,2);
names(1) = [];

DataMeans = mean(Data,1);
DataAdjusted = zeros(numrows, numcolumns);

x=1:numcolumns;
for i=1:numrows
    DataAdjusted(i,x)=Data(i,x)-DataMeans(x);
end

%% Step 2 : Creating the covariance matrix

S = cov(DataAdjusted);

%% Step 3 : Calculating the eigenvectors of the covariance matrix

%if sum(strcmp(varargin(:), 'GPU'))==1;
%    S = gpuArray(S);
%end
    
[eigvectors, eigvalues] = eig(S);

%if sum(strcmp(varargin(:), 'GPU'))==1;
%    eigvectors = gather(eigvectors);
%    eigvalues = gather(eigvalues);
%end

% eigvectors is already a normalized feature matrix, with the columns being
% the right eigenvectors of S

%numcomponents = 100;

x=1:numcomponents; %How many eigenvectors are left = how many principal components will be shown.
eigvectors = eigvectors(:,x);

eigvalues = diag(eigvalues); %Unravels the diagonal to a vector list.
%eigvectors and eigvalues are already sorted!

%% Step 4 : Deriving the new data set

Components = transpose(eigvectors)*transpose(DataAdjusted);
%Components = The original data solely in terms of the principal eigenvectors chosen.

%Components = [Components, names];

end

