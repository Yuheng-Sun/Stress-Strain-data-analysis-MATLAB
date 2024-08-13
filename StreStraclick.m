function [fStress_sStrain, UTSyx, maxEStress] = StreStraclick(DetectorDistance, Thickness, Width, processedData, numRows, TravelRows, ForceRows, f1)
    % Calulate Stress and Strain
    StressStrain = zeros(size(processedData));
    StressStrain(:, 1) = processedData(:, ForceRows) / (Thickness * Width);
    StressStrain(:, 2) = processedData(:, TravelRows) / DetectorDistance;
    % Get x & y
    y = StressStrain(:, 1);
    x = StressStrain(:, 2);

    sp = 0.15*round(numRows,-2); % around 0.15 of total data

    y1 = StressStrain(1:sp, 1);
    x1 = StressStrain(1:sp, 2);

    y2 = StressStrain(sp:numRows, 1);
    x2 = StressStrain(sp:numRows, 2);

    % polynomial
    n = 19; % root of polynomial
    [p1, S1, mu1] = polyfit(y1, x1, n);
    [p2, S2, mu2] = polyfit(x2, y2, n);

    % processed data
    aa = 2500;
    bb = 12500;
    y_fit1 = linspace(min(y1),max(y1), aa);
    [x_fit1, StressStrain] = polyval(p1, y_fit1, S1, mu1);
    
    x_fit2 = linspace(min(x2),max(x2), bb);
    [y_fit2, StressStrain] = polyval(p2, x_fit2, S2, mu2);

    % check
    figure(f1);
    plot(x, y);
    hold on;
    plot(x_fit1, y_fit1, 'b');
    hold on;
    plot(x_fit2, y_fit2, 'r');
    hold off
    legend show;
    title('Stress-Strain graph check');
    xlabel('strain');
    ylabel('stress[MPa]');
    
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off

    [x_point, y_point] = ginput(1);
    maxEStress = y_point;

    %first line is Stress second line is Strain
    y_fit = [y_fit1, y_fit2];
    x_fit = [x_fit1, x_fit2];

    fStress_sStrain = [y_fit(:), x_fit(:)];

    % get UTS
    UTSdata = sortrows(fStress_sStrain,1,'descend');
    UTSx = UTSdata(1,2);
    UTSy = UTSdata(1,1);
    UTSyx = [UTSy,UTSx];