global DataType 
long_value = 65545 ; 
SendObj( [hex2dec('2224'),1] , long_value , DataType.long ,'boom boom') ; %Set long
float_value = 20.15 ;
SendObj( [hex2dec('2224'),2] , float_value , DataType.float ,'boom boom') ; %Set

%through Kvaser
RetVal = FetchObj([hex2dec('2224'),1], DataType.long, ['pak pak']); %Get
RetVal = FetchObj([hex2dec('2224'),2], DataType.float, ['pak pak']);

%Through NetaCom
SendObj( [hex2dec('2224'),1] , 19 , DataType.long ,'boom boom', @NetaCom) ; %Set
SendObj( [hex2dec('2224'),2] , 19.5 , DataType.float ,'boom boom', @NetaCom) ; %Set

RetVal = FetchObj([hex2dec('2224'),2], DataType.float, ['pak pak'],@NetaCom); %Get - old version (only get one msg).
RetVal = FetchObj([hex2dec('2224'),1], DataType.long, ['pak pak'],@NetaCom); %Get - old version (only get one msg).

vec1 = {[hex2dec('2224'),2], DataType.float, ['pak pak']};
vec2 = {[hex2dec('2224'),1], DataType.long, ['pak pak']};

RetVal = FetchObjVec([vec1 ; vec2],@NetaCom); %Get - new version (fetch a vector).