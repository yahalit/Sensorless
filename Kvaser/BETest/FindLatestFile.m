function largestYFile = FindLatestFile(folderPath, Initials)

    % Get all .MAT files in the specified folder
    rule = [Initials, '*.hex'];
    files = dir(fullfile(folderPath, rule));
    
    % Initialize variables
    maxY = -inf;
    largestYFile = '';
    
    % Loop through each file
    for i = 1:length(files)
        % Get the current filename
        filename = files(i).name;
        
        % Extract the y value from the filename
        parts = strsplit(filename, '_');
        y = str2double(parts{end}(1:end-4)); % Remove '.mat' and convert to number
        
        % Check if this y is larger than the current max
        if y > maxY
            maxY = y;
            largestYFile = filename;
        end
    end
    
    % If no valid files were found, return empty string
    if isempty(largestYFile)
        disp('No valid files found.');
    else
        disp(['File with largest y: ', largestYFile]);
    end