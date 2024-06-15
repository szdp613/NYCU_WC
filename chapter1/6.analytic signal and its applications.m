function z = analytic_signal(x)
%Generate analytic signal using frequency domain approach
x = x(:); %serialize
N = length(x);
X = fft(x,N);
z = ifft([X(1); 2*X(2:N/2); X(N/2+1); zeros(N/2-1,1)],N);
end

%Test routine to check analytic_signal function
t=0:0.001:0.5-0.001;
x = sin(2*pi*10*t); %real-valued f = 10 Hz
figure(1); subplot(2,1,1); plot(t,x);%plot the original signal
title('x[n] - real-valued signal'); xlabel('n'); ylabel('x[n]');

z = analytic_signal(x); %construct analytic signal
subplot(2,1,2); plot(t, real(z), 'k'); hold on;
plot(t, imag(z), 'r');
title('Components of Analytic signal');
xlabel('n'); ylabel('z_r[n] and z_i[n]');
legend('Real(z[n])','Imag(z[n])');


%Demonstrate extraction of instantaneous amplitude and phase from
%the analytic signal constructed from a real-valued modulated signal.
fs = 600; %sampling frequency in Hz
t = 0:1/fs:1-1/fs; %time base
a_t = 1.0 + 0.7 * sin(2.0*pi*3.0*t) ; %information signal
c_t = chirp(t,20,t(end),80); %chirp carrier
x = a_t .* c_t; %modulated signal
figure(2); subplot(2,1,1); plot(x);hold on; %plot the modulated signal

z = analytic_signal(x); %form the analytical signal
inst_amplitude = abs(z); %envelope extraction
inst_phase = unwrap(angle(z));%inst phase
inst_freq = diff(inst_phase)/(2*pi)*fs;%inst frequency

%Regenerate the carrier from the instantaneous phase
regenerated_carrier = cos(inst_phase);

plot(inst_amplitude,'r'); %overlay the extracted envelope
title('Modulated signal & extracted envelope');xlabel('n');ylabel('x(t) & |z(t)|');
subplot(2,1,2); plot(cos(inst_phase));
title('Extracted carrier or TFS');xlabel('n'); ylabel('cos[\omega(t)]');


%Demonstrate simple Phase Demodulation using Hilbert transform
clearvars; clc;
fc = 210; %carrier frequency
fm = 10; %frequency of modulating signal
alpha = 1; %amplitude of modulating signal
theta = pi/4; %phase offset of modulating signal
beta = pi/5; %constant carrier phase offset
receiverKnowsCarrier= 'False';
%Set True if receiver knows carrier frequency & phase offset

fs = 8*fc; %sampling frequency
duration = 0.5; %duration of the signal
t = 0:1/fs:duration-1/fs; %time base
%Phase Modulation
m_t = alpha*sin(2*pi*fm*t + theta); %modulating signal
x = cos(2*pi*fc*t + beta + m_t ); %modulated signal

figure(3); subplot(2,1,1); plot(t,m_t) %plot modulating signal
title('Modulating signal'); xlabel('t'); ylabel('m(t)')
subplot(2,1,2); plot(t,x) %plot modulated signal
title('Modulated signal'); xlabel('t');ylabel('x(t)')

%Add AWGN noise to the transmitted signal
nMean = 0; nSigma = 0.1; %noise mean and sigma
n = nMean + nSigma*randn(size(t)); %awgn noise
r = x + n;  %noisy received signal

%Demodulation of the noisy Phase Modulated signal
z= hilbert(r); %form the analytical signal from the received vector
inst_phase = unwrap(angle(z)); %instaneous phase

%If receiver knows the carrier freq/phase perfectly
if strcmpi(receiverKnowsCarrier,'True')
    offsetTerm = 2*pi*fc*t+beta;
else %else, estimate the subtraction term
    p = polyfit(t,inst_phase,1);%linearly fit the instaneous phase
    %re-evaluate the offset term using the fitted values
    estimated = polyval(p,t); offsetTerm = estimated;
end
demodulated = inst_phase - offsetTerm;
figure(4); plot(t,demodulated); %demodulated signal
title('Demodulated signal'); xlabel('n'); ylabel('\hat{m(t)}');
