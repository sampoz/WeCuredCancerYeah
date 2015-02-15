function Components = ProjectPCA2(varargin)
%PROJECTPCA PCA done the hard way for the ICS-3000 project.
% We must start again. This time following:
% http://matlabdatamining.blogspot.fi/2010/02/principal-components-analysis.html
%
% Components = ProjectPCA(Data, txtData, args).
% Data, txtData from xlsread('source.xlsx')
%
% Accepted arguments =
% any integer -> amount of principal components returned
% 'plot' -> plots the selected components 
%
% Done and tested with Matlab 2014b

if nargin == 0;
    [Data, txtData] = xlsread('train.xlsx');
    %Data = xlsread('independant.xlsx')
else
    Data = varargin{1};
    txtData = varargin{2};
end

if nargin > 2;
    for i=1:nargin;
        if isnumeric(varargin{i})==1;
            numcomponents = varargin{i};
        end
    end
end

%% Step 1 : Cleaning, gathering, normalization.

x=2:2:size(Data,2);
Data(:,x) = []; 
%Removes all nonnumeric data from the data
%Data(isnan(Data))=[]; %is buggy, results in one vector.
Data(1,:) = []; %Index row in excel data

%Data = transpose(Data); %Fixes the dimension.
%Old = Rows are variables, columns observations.
%New = Columns variables, rows observations.

numcomponents = size(Data,1); % -1 from index row.

x=1:2;
txtData = txtData(:,x); %Names for the variables
names = txtData(:,2);
names(1) = [];

DataMean = mean(Data); %Means for the inverse tranform
DataStd = std(Data); %Standard deviations for the inverse transform

DataNormalized = zscore(Data);
%Centers and scales the data

%[coeff, score, latent, tsquare, explained]= princomp(Data);

%Components = score;

%% Eigenvectors & eigenvalues

S = cov(DataNormalized); %Calculates the covariance matrix

[eigvectors, eigvalues] = eig(S); %Calculates the eigenvectors and eigenvalues of the covariance matrix.
%eigvectors are the coefficients for the principal components

latent = diag(eigvalues); %The eigenvalues can be used to map the variance explained by the principal components left.

%% Calculating the final PCs

Components = DataNormalized*eigvectors;

[coeff, score, latent] = princomp(Data);


%% Inverse transform

%A2 = transpose(V)*DataNormalized;

%% Plotting

if sum(strcmp(varargin(:), 'Plot'))==1;
    
    figure()
    
    %biplot(Components(:,1:2),'Scores',score(:,1:2),'VarLabels', {'X1' 'X2' 'X3' 'X4'})
    
    pareto(explained);
    xlabel('Principal Component')
    ylabel('Variance Explained (%)')
    
    %figure(); boxplot(Data,'orientation', 'horizontal', 'labels', names);
    
    %Simple 2d comparison between first and second PC
    %plot(score(:,1),score(:,2),'+')
    %xlabel('1st Principal Component')
    %ylabel('2nd Principal Component')
end



