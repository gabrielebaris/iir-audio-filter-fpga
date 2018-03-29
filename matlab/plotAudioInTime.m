function  plotAudioInTime(audio, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    t = linspace(0, length(audio)/Fs, length(audio));
    plot(t, audio);
    
end

