function [F,TF]=Findfft(Signal,Ts,Hz,F0,Plot,color,rem)
% Signal  - For which to find fft at F0
% Ts      - samplig time of Signal
% Hz      = F0 in [Hz]. MUST be in [Hz]!
% F0      - list of frequencies [Hz]
% Plot    = 1 to plot for analysis
% color   - choice of color plot 
% rem     - 1 an important remark (no input or 0 - no remarks)
%
%   Author: Oded Yaniv, cell: 0544893673
%   Copyrigrid on; hold on;t BugProof, Inc.
%   Written: July 2022
%   Customers are not allowed to sell/give/show/transfer/copy this m.file to a third party without written permission from Oded Yaniv.
%

if(nargin==5)
    color = 'r.-';
    clr   = 'ob';
else
    if(strcmp(color,'b'))
        clr = 'or';
    else
        clr = 'ob';
    end
    color = [color '.-'];
end
if(nargin==7 && rem==1)
    fprintf('Check that your Signal do not miss points!!!!\n')
    fprintf('That is: Signal fits the time units 0:Ts:(Length-1)*Ts\n')
end
Signal = Signal-sum(Signal)/length(Signal);%remove DC
Len    = length(Signal);
%Fix length to integer number of frequencies
%If freqs chosen peoperly no need
% % % if(0)
% % %     %Seems something is wrong
% % %     Signal = FixLength4Iden(Signal,Ts);
% % %     Len    = length(Signal);
% % % end
fftw   = (0:Len-1)/Len/Ts*2*pi;
if(strcmp(Hz,'Hz'))
    w0 = F0*2*pi; %go to rad/sec
else
    error('Input frequencies must be in Hz, not rad/sec')
end
if(nargin>=4 && ~isempty(w0))
    I = find(fftw>=w0,1,'first');
    [~,II] = min(abs(fftw(I-1:I)./w0-1));
    if(II==1)
        I = I-1;
    end
else
    error('Check line 61: [~,Im]  = max(fftSignalA(2:end)), replace [~,I]  = max(fftSignalA(1:end))')
    I = [];
end
fftSignal    = fft(Signal)/sqrt(Len);
fftSignalA   = abs(fftSignal);
% ind    = 1 + w/2/pi*Len*Ts;
% ind    = round(ind);
if(isempty(I))
    [~,Im] = max(fftSignalA(2:end));
    I      = Im+1;
else
    [~,Im]  = max(fftSignalA(2:end));
end
IA   = length(fftSignalA);%find(fftw>3*F*2*pi,1);
fftw = fftw(:);
if(strcmp(Hz,'Hz'))
    if(Plot)
        plot(fftw(2:IA)/2/pi,fftSignalA(2:IA),color);grid on; hold on;
        plot(fftw(I)/2/pi,fftSignalA(I),clr);grid on; hold on;
        xlabel('Hz');
    end
    TF = fftSignal(I);
    F  = fftw(I)/2/pi;
else
    if(Plot)
        plot(fftw(2:IA),fftSignalA(2:IA),color);grid on; hold on;
        plot(fftw(I),fftSignalA(I),clr);grid on; hold on;
        xlabel('rad/sec');
    end
    TF = fftSignal(I);
    F  = fftw(I);
end
