function plotAudioInFrequency(original, filtered, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fy=fft(int16(original));
L=length(original);
L2=round(L/2);
fa=abs(fy(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies

fy_filt = fft(int16(filtered));
ff=abs(fy_filt(1:L2));


plot(fq,fa, fq, ff);

end

