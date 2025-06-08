function [fftSignalA,fftw]=fftFull(Signal,Ts,Hz,Plot,color)

% Remove DC
if(nargin==4)
    color  = 'red';
end
Signal = Signal-sum(Signal)/length(Signal);%remove DC

Len    = length(Signal);
fftw   = (0:Len-1)/Len/Ts*2*pi;

fftSignal    = fft(Signal)/sqrt(Len);
fftSignalA   = abs(fftSignal);

IA   = length(fftSignalA);%find(fftw>3*F*2*pi,1);
fftw = fftw(:);
if(strcmp(Hz,'Hz'))
    if(Plot)
        plot(fftw(2:IA)/2/pi,fftSignalA(2:IA),color);grid on; hold on;
        xlabel('Hz');
    end
else
    error('TBW')
end
