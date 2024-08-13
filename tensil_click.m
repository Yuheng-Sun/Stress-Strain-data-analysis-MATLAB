%% Step 1
clc;
close all;
clear
%% Step 2
lgd = legend;
lgd.AutoUpdate = 'off';
% fixed parameters input
%detetor distance or total distance
DetectorDistance = 5;% mm 
%travel and force in which rows of ur data
TravelRows = 1;
ForceRows = 2;
iii = 1;
% Set the memory table and figures
outputTable = table([],[],[],[],[],[],[],[],[],[],'VariableNames',{'Number','Sample Name','UTS [MPa]','Eu','Ef','E-modulus','Yield Strength [MPa]','Ey','theta[MPa]','Etheta'});
StressStrainCur = figure('Name','Stress vs Strain', 'NumberTitle', 'off');
TrueStressStrainCur = figure('Name','True Stress vs True Strain', 'NumberTitle', 'off');
%% Step 3 !!!!!!START!!!!!!!!!FROM!!!!!!!!!!!!!!HEAR!!!!!!!!!!!!
clc;
%% Step 4 !!change them every time befor go to next part
SampleName = "1300-1h-2";
filePath = 'D:\MATLABcode\tensile test\20240725\S16.TXT';
Thickness = 1.05; % mm
Width = 1.79; % mm
%% Step 5
f1 = figure;
[processedData, numRows] = TXT2Array(filePath);
[fStress_sStrain, UTSyx, maxEStress] = StreStraclick(DetectorDistance, Thickness, Width, processedData, numRows, TravelRows, ForceRows, f1);
StressStrainData = fStress_sStrain;
UTS = UTSyx(1,1);
eu = UTSyx(1,2);
ef = max(StressStrainData(:,2));
%% Step 6
close(f1);
f2 = figure;
[E_Modulus, YieldPoint] = ES_YSclick(DetectorDistance, Thickness, Width, processedData, numRows, maxEStress, TravelRows, ForceRows, f2);
YongsModulus = E_Modulus;
%% Step 7
close(f2);
f3 = figure;
Y_strength = YieldPoint(1,2);
Y_strain = YieldPoint(1,1);
[TrueStressStrain, StrainHardingRate, ThetaPoint] = TrueSSclick(fStress_sStrain, f3);
%% Step 8
theta = ThetaPoint(1,2);
E_theta = ThetaPoint(1,1);
close(f3);
%% Step 9
newdata = table([iii],[SampleName],[UTS],[eu],[ef],[E_Modulus],[Y_strength],[Y_strain],[theta],[E_theta],'VariableNames',{'Number','Sample Name','UTS [MPa]','Eu','Ef','E-modulus','Yield Strength [MPa]','Ey','theta[MPa]','Etheta'});
outputTable = [outputTable;newdata]
writetable(outputTable, '20240725TensileTest.csv');
iii = iii+1;

figure(StressStrainCur);

plot(fStress_sStrain(:,2),fStress_sStrain(:,1),'DisplayName',SampleName);
legend show;
title('Stress-Strain');
xlabel('strain');
ylabel('stress[MPa]');
legend show;
hold on;

figure(TrueStressStrainCur);
plot(TrueStressStrain(:,2),TrueStressStrain(:,1),'DisplayName',SampleName);
legend show;
title('True Stress- True Strain');
xlabel('True strain');
ylabel('True stress[MPa]');
legend show;
hold on;
%% Step 10
disp('return')