function [ALLindices, AMLindices] = ProjectCorr(varargin)
%% PROJECTCORR Calculates the correlation coefficients
% and returns a vector containing a index vector containing all genes that
% have a correlation coefficient of > Threshold.
% ProjectCorr(Data, N, threshold, 'Plot');

Data = varargin{1};
N = varargin{2}; 
Threshold = varargin{3};

x=1:27;
ClassV = zeros(38,1); %38 is the amount of patients
ClassV(x) = 1; %

ALLrho = corr(transpose(Data), ClassV);
AMLrho = corr(transpose(Data), not(ClassV));

ALLindices = zeros(numel(ALLrho),1);
AMLindices = zeros(numel(AMLrho),1);

for i=1:N; %Fills the index vector with the N most correlated genes.
    ALLindices(ALLrho == max(ALLrho))=1; 
    AMLindices(AMLrho == max(AMLrho))=1;
    if ALLindices(i) && AMLindices(i);
        %If the gene is strongly correlated to both leukemias, its not useful as a classifier.
        if (max(AMLrho)> Threshold) && (max(ALLrho)> Threshold); 
            ALLindices(i) = 0;
            AMLindices(i) = 0;
        end
    end
    ALLrho(ALLrho == max(ALLrho))=0;
    AMLrho(AMLrho == max(AMLrho))=0;
end
%Return is two N sized vectors, so 2N genes will be selected for the PCA.


%Both = ALLindices+AMLindices;
%CorrelatedBoth = Both(Both == 2); %0 in the training data with Threshold = 0.3 .

AMLrhosorted = sort(AMLrho);
%ALLrhosorted = sort(ALLrho);

%Data = transpose(Data); %Rows are observations, columns variables for corrcoef
%Corrs = corrcoef(Data); 

%% Plotting for testing
if sum(strcmp(varargin(:), 'Plot'))==1;
    x = 1:numel(AMLrhosorted);
    plot(AMLrhosorted, x);
    %plot(ALLrhosorted, x);
end
