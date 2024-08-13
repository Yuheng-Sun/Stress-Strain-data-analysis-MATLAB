function [TrueStressStrain, StrainHardingRate, ThetaPoint] = TrueSSclick(fStress_sStrain, f3)

    % Engineering Stress & Strain
    engStress = fStress_sStrain(:, 1);
    engStrain = fStress_sStrain(:, 2);

    % True Stress
    trueStress = engStress .* (1 + engStrain);

    % True Strain
    trueStrain = log(1 + engStrain);

    
    TrueStressStrain = [trueStress, trueStrain];

    %plot
    figure(f3);
    plot(trueStrain, trueStress,'y');
    hold on;
    legend show;
    title('True Stress-True Strain graph check');
    xlabel('true strain');
    ylabel('true stress[MPa]');

    % Calculate the number of points to select
    numPoints = size(TrueStressStrain, 1);
    startIndex = round(0.3 * numPoints) + 1;
    
    % Select the last 80% of the data points
    selectedData = TrueStressStrain(startIndex:end, :);
    selectedTrueStrain = selectedData(:, 2);
    selectedTrueStress = selectedData(:, 1);

    % Calculate the derivative of true stress with respect to true strain
    dTrueStress_dTrueStrain = diff(selectedTrueStress) ./ diff(selectedTrueStrain);

    % Since the diff function reduces the length by 1, adjust the true strain
    adjustedTrueStrain = selectedTrueStrain(1:end-1);
    StrainHardingRate = [dTrueStress_dTrueStrain,adjustedTrueStrain];

    % Plot the derivative
    plot(adjustedTrueStrain, dTrueStress_dTrueStrain);
    xlabel('True Strain');
    ylabel('d(True Stress) / d(True Strain)');
    title('True Stress-Strain Derivative');
    axis([-0.1 0.5 0 1700]);
    grid on;
    
    zoom on;
    waitfor(gcf, 'CurrentCharacter', char(13))
    zoom reset
    zoom off
    [x_point, y_point] = ginput(1);
    ThetaPoint = [x_point, y_point];