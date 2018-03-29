function buildTxtFiles(name, original, filtered)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

samples = 1000;
inFile = fopen(strcat('test/', name, '_in.txt'), 'w');
outFile = fopen(strcat('test/', name, '_out.txt'), 'w');


% Generating files
for i=1:samples
    fprintf(inFile, '"%s",\n', bin(original(i)));
    fprintf(outFile, '"%s",\n', bin(filtered(i)));
end

end

