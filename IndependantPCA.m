function [indcoeff,indcomponents] = IndependantPCA(varargin)
%INDEPENDANTPCA Second iteration of projectPCA for the independant data set.

Data = varargin{1};
PCAindices = varargin{2};
PCAnames = varargin{3};
if nargin>3;
    N = varargin{4}; %For the figures.
end

%% Step 1 : Cleaning and gathering.

x=2:2:size(Data,2);
Data(:,x) = []; 
%Removes all nonnumeric data from the data
%Data(isnan(Data))=[]; %is buggy, results in one vector.
Data(1,:) = []; %Index row in excel data

%% Step 2 : Reducing the dataset

Data(~PCAindices,:) = [];

%% Step 3 : The PCA

[coeff, components, latent, tsquare, explained]= princomp(transpose(Data));
% In the dataset the genes are the variables and the test subjects are the
% observations. Princomp takes in the inverse.

%% Step 4 : Visualization for the independant data: 

if sum(strcmp(varargin(:), 'Plot'))==1;
    figure()
    biplot(coeff(:,1:2),'scores',components(:,1:2),'varlabels', PCAnames);
    title(['First two principal components of the independant dataset, reduced to ', num2str(2*N) ,' genes '])
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
    figure()
    pareto(explained)
    title(['Percentage of variance of ', num2str(2*N), ' genes, explained by principal components'])
    xlabel('Principal Component')
    ylabel('Variance Explained (%)') 
end

%% Renaming the returns

indcoeff = coeff;
indcomponents = components;