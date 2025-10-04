%AnaAll    Analyze the results of L by angle determination

files = dir('FEsraVoltExpRslt*.mat');
Ts = 5e-6    ; 

eind = [6,2,4,3,5,1] ; 

anafiles = cell(1,length(files)) ; 
angpuVec = zeros(1,length(files)) ;
segVec = zeros(1,length(files)) ;

nfiles = 0 ; 
for cnt = 1:length(files) 
    % Get the next file 
    next = files(cnt).name ; 
    place = strfind(next,'_') ; % In the file mame, underscore stands for field seperator 
    
    if length(place) == 3 
        placeperiod =  strfind(next,'.') ;
        angpu = str2double( next( place(1)+1:place(2)-1 ) ) ;   % File name encodes field angle that set the rotor in place
        amps  = str2double( next( place(2)+1:place(3)-1 ) ) ;   % Amperage limit 
        seg   = str2double( next( place(3)+1:placeperiod(end)-1 ) )  ; % The segment - which phase received current, which was current exit
        
        if seg <= 5 
            % Segments when current goes from a single phase to a single phase, with the 3rd phase open 
            % disp(next + " ang:" + num2str(angpu)+ "seg:" + num2str(seg)) ;
            nfiles = nfiles +  1;  % Increment the number of files in use 
            anafiles{nfiles} = next ; % Take statistics of selected files 
            angpuVec(nfiles) = angpu ; 
            segVec(nfiles) = seg + 1   ; 
        end
    end
end

% Truncate the file list to leave only the populated part 
anafiles = anafiles(1:nfiles) ; 
angpuVec = angpuVec(1:nfiles) ; 
segVec = segVec(1:nfiles) ; 

% M = [angpuVec(:), segVec(:)];     % Combine as columns
% [M_sorted,M_index] = sortrows(M, [1 2]);  % Sort by A, then B
% Get an as a vector of electrical angles out of the segments 
an = segVec * 0 ;
for cnt = 1:nfiles 
    an(cnt) = ( eind(segVec(cnt)) - 0.5) / 6 + angpuVec(cnt) ; 
end
an = mod( an , 1) ;

% Sort electrica-angle wise 
[an,M_index] = sort(an) ;

% angpuVec = M_sorted(:,1);
% segVec = M_sorted(:,2);

% Apply the sorting to all the file statistics 
angpuVec = angpuVec(M_index) ; 
segVec = segVec(M_index) ; 
anafiles = anafiles(M_index);

% Obtain resistance estimates for all, so calculating the inductance will pose a linear problem 
% Note that R here includes all the experiment's cables and connectors 
Rvec = angpuVec * 0 ; 
Deg30 = 0 ; 
doplot = 0 ; 
VdcOverRide = 28 ;
Ccell = cell(1,nfiles) ; 
Vcell   = cell(1,nfiles) ; 
rcell   = cell(1,nfiles) ; 
for cnt = 1:nfiles
   disp( "an: " + num2str(an(cnt)) + " : " + anafiles{cnt} +  " angPu:" + num2str(angpuVec(cnt))+ "seg:" + num2str(segVec(cnt))) ;
   [Rvec(cnt),Ccell{cnt},Vcell{cnt},rcell{cnt}] = CalcR(anafiles{cnt},segVec(cnt) , Deg30,doplot,VdcOverRide)  ;
end
R = mean(Rvec) ; 

% Loop over all the files to find inductance. Inductance is modeled like 
% L0 + (optional) L1 * I + (optional) L2 * I^2
L0 = Rvec * 0 ;
L1 = Rvec * 0 ; 
L2 = Rvec * 0 ; 

for seq = 1:nfiles
    V = Vcell{seq};
    Cur = Ccell{seq};
    Ts  = rcell{seq}.Ts ;

    ind1 = 2:length(V) ;

    veff = V(ind1) - Cur(ind1) * R ; 
    ceff = Cur(ind1) ; 
    H    = [ veff , veff.* ceff ] ; % , veff .* (ceff.^2) ] ;
    Y    = diff( Cur) / Ts  ; 
    tht  = (H' * H) \ H' * Y  ;
    tht = [tht ; 0]; %#ok<AGROW>

    %figure(seq+10) ; 
    %CurSim = Cur * 0 ; 
    %plot( t , Cur , t , CurSim ) ;

    L0(seq) = 1 / tht(1) ; 
    L1(seq) =  tht(2) / tht(1)^2 ; 
    L2(seq) =  (tht(2)^2 - tht(1) * tht(3)) / tht(1)^3 ; 
end
figure(20) ; clf 

for cnt = 2:length(L0) 
    if abs( an(cnt) - an(cnt-1)) < 0.01 
        an(cnt) = an(cnt-1) ; 
    end
end 
d = diff( an) ; 
nd = find(d) ;
L00 = zeros( length(nd)+1,1  ) ; 
an0 = L00 ; 
for cnt = 1:length(nd)
    if ( cnt == 1) 
        ind = 1:(nd(cnt)); 
    else
        ind = (nd(cnt-1)+1):(nd(cnt)); 
    end
    
    L00(cnt) = mean(L0(ind))  ; 
    an0(cnt) = mean(an(ind))  ;  
end
ind = (nd(end)+1):length(an); 
L00(end) = mean(L0(ind))  ; 
an0(end) = mean(an(ind))  ;  


plot( an0 , L00 , 'd' ) ;
% Go to analysis