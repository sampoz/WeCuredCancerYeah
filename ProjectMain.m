%% PROJECTMAIN
% a script for running and plotting the PCAs for the ICS-3000.

if exist('ALL', 'var') == 0;
    [ALL, ALLtxt] = xlsread('ALL.xlsx');
    if exist('AML', 'var') == 0;
        [AML, AMLtxt] = xlsread('AML.xlsx');
    end 
end

