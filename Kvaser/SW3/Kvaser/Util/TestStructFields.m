function missList =TestStructFields(s1,list,name)
%
% s=TestStructFields(s1,list)
%
% Test that all specified fields exist in a struct 
% s1 = tested tsruct 
% list = cell array of tested field names 
% name [optional] : as string, name of tested var
% If no output argument is given, throws an error

if nargin < 3 
    name = [] ; 
end 

if ~isstruct(s1) || isempty(s1) 
    error('Argumet must be a non empty struct') 
end 

if ~iscell(list) || isempty(list) 
    error('Argumet must be a non empty cell array') 
end 

list = list(:) ; 
nlist = length(list) ; 

for cnt = 1:nlist 
    if isempty( list{cnt}) 
        error('List of fields contains empty entity')   
    end 
    list{cnt} = char( list{cnt} ) ; 
end 

fn=fieldnames(s1);
missList = setdiff(list,fn) ; 



if ( ~isempty(missList)) && nargout < 1 
    if ~isempty(name)
        name = ['Var:', name,':'];
    end
    error( [name,'TestStructFields:inputError , Missing fields ',Cell2Char(missList)] ) ; 
end



