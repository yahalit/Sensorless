function names = getProjFromID(IndexToName, ProjIDList)
    % Convert the cell array to a table for easier indexing
    %T = cell2table(searchIndices, 'VariableNames', {'Index', 'Name'});
    
    % Initialize the output cell array
    %names = cell(size(searchIndices));
    
    Indexes = cell2mat(IndexToName(:,1));

    ProjIndexes = zeros(size(ProjIDList));
    % Loop through each search index
    for i = 1:size(ProjIDList,1)
        % Find the row where the index matches
        try
            ProjIndexes(i) = find(Indexes-ProjIDList(i) == 0);
        catch
            ProjIndexes(i) = 0;
        end
    end
    %     % If a match is found, add the corresponding name
    %     if any(row)
    %         names{i} = T.Name{row};
    %     else
    %         names{i} = 'Unidentified';
    %     end
    % end
    
    % Convert cell array to string array
    try
        names = IndexToName(ProjIndexes,2);
    catch
        names = '';
        errordlg('could Not locate all project names.');
    end
end