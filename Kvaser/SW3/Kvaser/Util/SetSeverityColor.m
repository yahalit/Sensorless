function [bg,fg] = SetSeverityColor( value ,ini )

junk = find ( value < ini.ColorSwPoints , 1) ; 
if isempty(junk) 
    [junk,~] = size( ini.BgColorTable) ; 
end
bg = ini.BgColorTable(junk,:) ; 
fg = ini.FgColorTable(junk,:) ; 