function [E_Modulus, YieldPoint] = ES_YSclick(DetectorDistance, Thickness, Width, processedData, numRows, maxEStress, TravelRows, ForceRows, f2)
        
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


    % polynomial
    n = 19; % root of polynomial
    [p1, S1, mu1] = polyfit(y1, x1, n);

    sp3 = 0.15*round(numRows,-2);
    y3 = StressStrain(sp3:numRows, 1);
    x3 = StressStrain(sp3:numRows, 2);
    [p3, S3, mu3] = polyfit(x3, y3, n);

    % processed data
    aa = 5000;
    y_fit1 = linspace(min(y1),max(y1), aa);
    [x_fit1, StressStrain] = polyval(p1, y_fit1, S1, mu1);

    % plot
    figure(f2);
    plot(x, y,'black .');
    hold on;
    plot(x_fit1, y_fit1, 'b');
    hold on
    legend show;
    title('Stress-Strain graph check');
    xlabel('strain');
    ylabel('stress[MPa]');

    %first line is Stress second line is Strain
    LSSCurve = [y_fit1(:), x_fit1(:)];

    % Find the point with the smallest strain
    [minStrain, minStrainIdx] = min(LSSCurve(:, 2));
    pp1 = LSSCurve(minStrainIdx, :);

    % Find the point with the stress closest to maxStress
    [~, closestIdx] = min(abs(LSSCurve(:, 1) - maxEStress));
    pp2 = LSSCurve(closestIdx, :);

    % Calculate the elastic modulus (slope of the line between p1 and p2)
    E_Modulus = (pp2(1) - pp1(1)) / (pp2(2) - pp1(2));
    y_interr = pp1(1) - E_Modulus * pp1(2);
    y_shift_interr = y_interr - E_Modulus*0.002;

    % Shift the line by 0.02 units along the strain axis
    ShiftStartPoint = pp1(2)+0.002;
    ShiftEndPoint = LSSCurve(aa,2)+0.002;
    x2 = linspace(minStrain,LSSCurve(aa,2),aa);
    y2 = E_Modulus * x2 + y_interr;
    y2_shift = E_Modulus * x2 + y_shift_interr;
    p2 = polyfit(x2, y2, 1);
    plot(x2, y2,'y');
    hold on;
    plot(x2, y2_shift, 'r');
    axis([-0.01 0.02 0 700]);
    hold off
    
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off

    [x_point, y_point] = ginput(1);
    
    YieldPoint = [x_point, y_point];
  

end