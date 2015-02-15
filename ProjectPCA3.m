function [coeff, components] = ProjectPCA3(varargin)
%PROJECTPCA PCA done the hard way for the ICS-3000 project.
% Components = ProjectPCA(Data, txtData, independantData, independanttxtData, args).
% Data, txtData from xlsread('source.xlsx')
%
% Accepted arguments =
% any integer N -> amount of genes used for the PCAs.
% 'plot' -> plots the selected components 
%
% Done and tested with Matlab 2014b

if nargin == 0;
    [Data, txtData] = xlsread('train.xlsx');
    independantData = xlsread('independant.xlsx');
else
    Data = varargin{1};
    txtData = varargin{2};
    independantData = varargin{3};
end

threshold = 0.3; %A Pearson's correlation coefficient used to examine the covariances
% in the data; any gene correlating with both ALL and AML over the
% threshold will be noted and disregarded as being useless as a
% classifier.

N = 50; %taken from the research paper, no error was produced in the original 
% class predictor done by Golub et. al. when sweeping N from 10 to 200 

if nargin > 3;
    for i=1:nargin;
        if isnumeric(varargin{i});
            N = varargin{i};
        end
    end
end

%% Step 1 : Cleaning and gathering.

x=2:2:size(Data,2);
Data(:,x) = []; 
%Removes all nonnumeric data from the data
%Data(isnan(Data))=[]; %is buggy, results in one vector.
Data(1,:) = []; %Index row in excel data

x=1:2;
txtData = txtData(:,x); %Names for the variables
names = txtData(:,2);
names(1) = [];

%% Step 2 : Correlations, N significant genes

%Genes = ProjectCorr(Data, names, N); %Genes is an label matrix
[ALLindices, AMLindices] = ProjectCorr(Data, N, threshold);

PCAindices = zeros(numel(ALLindices),1);

PCAindices(AMLindices | ALLindices)=1;
PCAnames = names(PCAindices == 1);

%% Step 3 : Reducing the dataset

Data(~PCAindices,:) = [];

%% Step 4 : PCA for the training data

[coeff, components, latent, tsquare, explained]= princomp(transpose(Data));
% In the dataset the genes are the variables and the test subjects are the
% observations. Princomp takes in the inverse.

%explained(1:5)

%% Visualization for the training data

if sum(strcmp(varargin(:), 'Plot'))==1;
    
    %figure()
    %vbls = {'X1', 'X2', 'X3'};
    %subplot(2,2,1)
    %biplot(coeff(:,1:2),'scores',components(:,1:2),'varlabels', PCAnames);
    %title(['First two principal components of the train data set, dataset reduced to ', num2str(2*N) ,' genes '])
    %xlabel('1st Principal Component')
    %ylabel('2nd Principal Component')
    %2D
    
    %biplot(coeff(:,1:3),'scores',components(:,1:3),'varlabels', PCAnames);
    %3D
    
    %figure()
    %pareto(explained)
    %title(['Percentage of variance of ', num2str(2*N), ' genes, explained by principal components'])
    %xlabel('Principal Component')
    %ylabel('Variance Explained (%)')
    
    %biplot(coeff(:,1:2),'Scores',components(:,1:2),'VarLabels', {'X1' 'X2' 'X3' 'X4'})
    
    %figure(); boxplot(Data,'orientation', 'horizontal', 'labels', names);
    
    %Simple 2d comparison between first and second PC
    %plot(components(:,1),components(:,2),'+')
    %xlabel('1st Principal Component')
    %ylabel('2nd Principal Component')
end

%% Second iteration of PCA for the independant dataset

[indcoeff, indcomponents] = IndependantPCA(independantData, PCAindices, PCAnames, N, 'Plot');
