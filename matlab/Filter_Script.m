% -------------------------------------------------------------------------
% Matlab script to analyze the design of a FIR
% -------------------------------------------------------------------------
% Author(s)   : Gabriele Meoni, Luca Pilato
% Date        : May 2017
% File name   : Filter_Sript.m
% Description : 
% -------------------------------------------------------------------------
% Input       : 
% Output      : 
% -------------------------------------------------------------------------

clc
clear
close all

% Pulse shaping filter analysis
% Sync filter
% -------------------------------------------------------------------------

A = 1; % Amplitude of the sync pulse
T = 0.001; % Period, Zeros of the Sinc, one lobe
Ts = 0.00025; % Sample rate of the input signal
rho = T/Ts; % Oversample Factor of the filter, 4 samples per lobe
N_lobes = 10; % Number of lobes, windowing of the filter
N_MAX = N_lobes*rho; % Number of pulse sampling points (coefficients of the filter)
h = A*sinc((-N_MAX/2:(N_MAX/2-1))*1/rho); % Filter pulse shape, sampled
h(abs(h)<=eps) = 0; % Resolve floating point resolution errors
h = h / sum(h); % Normalization, 0 dB @ w=0

figure
stem((-N_MAX/2 : N_MAX/2 - 1),h);
title('impulse respone, FIR coefficients');

% Delta response, impulse
% -------------------------------------------------------------------------
x = [zeros(1,numel(h)/2),1,zeros(1,numel(h)/2 - 1)]; % Delta as Input

y = conv(h,x); % convolution: LENGTH(A)+LENGTH(B)-1

% figure
% stem(y); % filtered Output
% title('delta FIR response (impulse)');

% Analysis of the Filter, with given coefficients
% -------------------------------------------------------------------------
fvtool(h); % Filter

% --> try to change the oversampling (rho)
% --> try to change the window (Nlobes)

% Quantization
% -------------------------------------------------------------------------
b_x = 8; % Number of bit for the input (C2)

% How to quantize the coefficients?   2 strategy
% -------------------------------------------------------------------------
% 1) Fix the lsb value
lsb_h = min(abs(h(ne(h,0)))); % minimum positive value as the lsb
h_q   = round(h/lsb_h); % quantized coefficients
b_h   = ceil(log2(max(h_q)+1))+1; % number of bit to represent C2 coefficients

% plot
figure
stem(h,'b');
hold on
stem(h_q*lsb_h,'r'); % Rescale in the range of h
title('Qauntization: float vs fixed-point cefficients (1st method)');

% -------------------------------------------------------------------------
% 2) Fix the range, number of bits
b_h   = 10;
lsb_h = max(h) / (2^(b_h-1)-1); % C2 balanced
h_q   = round(h/lsb_h); 

% plot
figure
stem(h,'b');
hold on
stem(h_q*lsb_h,'r'); % Rescale in the range of h
title('Qauntization: float vs fixed-point cefficients (2nd method)');

% Comparison of the second method
% -------------------------------------------------------------------------
fvtool(h,1,h_q*lsb_h,1);

% Output range, wordlength?
% -------------------------------------------------------------------------
b_out = b_x + ceil(log2(sum(abs(h_q))));


% Try to filter a signal;
% -------------------------------------------------------------------------
N_sample = 400;
fs       = 1/Ts; % sampling frequency (fs/2 is nyquist)
f0       = fs/100;
A_x      = 4; % max 4
x        = A_x*sin(2*pi*f0*(1:N_sample)*Ts);
x        = x + 0.3*randn(size(x)); % add noise

% x quantization, suppose C2-ADC b_x bit, lsb = 5/2^(b_x-1);
% -------------------------------------------------------------------------
lsb_x = 5/2^(b_x-1);
x_q   = floor(x/lsb_x); 

% bit-true filtering (with integers)
% -------------------------------------------------------------------------
y_out = conv(x_q,h_q);

figure
plot(x_q*lsb_x,'b');
hold on
plot(y_out*lsb_x*lsb_h,'r');
title('Noisy input and filtered output (de-quantized)');
grid on

% Optimization in data-path
% -------------------------------------------------------------------------
b_tr_mul = 4; % truncation after multipliers
b_tr_out = 8; % truncation at the output

% x padding for manual convolution
x_q_padded = [zeros(1,N_MAX) x_q zeros(1,N_MAX)];

% multiplier
for n = 1:N_sample
  y_mul(n,:) = h_q.*x_q_padded(n+(0:N_MAX-1)); % N_sample x N_MAX
end

% truncation on multiplier
y_mul = floor(y_mul./2^b_tr_mul);

% adder tree
y_out_tr = sum(y_mul,2); % summation by cols

% truncation on out
y_out_tr = floor(y_out_tr/2^b_tr_out);

% check the error

figure
plot(x_q*lsb_x,'b');
hold on
plot(y_out*lsb_x*lsb_h,'r');
plot(y_out_tr*lsb_x*lsb_h*2^(b_tr_mul+b_tr_out),'k');
title('Noisy input and filtered output, normal + truncated (de-quantized)');
grid on

% -> try to change the amplitude of the input sin (see non-linearity in response)

b_out_tr = b_out - b_tr_mul - b_tr_out;

% -------------------------------------------------------------------------
% END OF SCRIPT



