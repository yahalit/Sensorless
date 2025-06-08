%measure = struct ('x', 0, 'y', 0);
%measures = repmat(measure,1,20);

%required to set #define DEBUG_SIDE_CAMERA

measuresX = zeros(1,20);
measuresY = zeros(1,20);
measuresAz = zeros(1,20);
measuresTime = zeros(1,20);

for i = 1:20 
    SendObj([hex2dec('2220'), 150],1, DataType.long,'');

    tic
    while( FetchObj([hex2dec('2220'), 157],DataType.float,'') ~= 0 )
    end
    measuresTime(i) = toc;
    pause(0.1);

    measuresX(i) = FetchObj([hex2dec('2220'), 151],DataType.float,'');
    measuresY(i) = FetchObj([hex2dec('2220'), 152],DataType.float,'');
    measuresAz(i) = FetchObj([hex2dec('2220'), 153],DataType.float,'');

    disp(['measure #', num2str(i),', results: x=', num2str(measuresX(i)), ...
        ', y=', num2str(measuresY(i)), ', Azimuth: ', num2str(measuresAz(i)), ', time: ',num2str(measuresTime(i))]);
end
STDx = std( measuresX );
STDy = std( measuresY );
STDAz = std( measuresAz );

disp(['STDx: ', num2str(STDx), ', STDy: ' num2str(STDy), ', STD Az: ' num2str(STDAz)]);
