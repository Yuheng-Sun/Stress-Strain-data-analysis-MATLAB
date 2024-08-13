function [processedData, numRows] = TXT2Array(filePath)

    % read file
    fileID = fopen(filePath, 'r');
    
    if fileID == -1
        error('can not open %s', filePath);
    end
    
    % read first and second line
    titleline = fgetl(fileID);
    unitsline = fgetl(fileID);
    
    % read dataset (num only)
    data = fscanf(fileID, '%f %f %f', [3 Inf])';
    
    % got processed data
    processedData = data;
    
    % get number of rows
    numRows = size(processedData, 1);

end
