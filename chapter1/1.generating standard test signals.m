f=10; %frequency of sine wave
overSampRate=30; %oversampling rate
fs=overSampRate*f; %sampling frequency
phase = 1/3*pi; %desired phase shift in radians
nCyl = 5; %to generate five cycles of sine wave
t=0:1/fs:nCyl*1/f-1/fs; %time base
g=sin(2*pi*f*t+phase); %replace with cos if a cosine wave is desired
figure(1); plot(t,g); title(['Sine Wave f=', num2str(f), 'Hz']);


f=10; %frequency of sine wave in Hz
overSampRate=30; %oversampling rate
fs=overSampRate*f; %sampling frequency
nCyl = 5; %to generate five cycles of square wave
t=0:1/fs:nCyl*1/f-1/fs; %time base
g = sign(sin(2*pi*f*t));
figure(2); plot(t,g); title(['Square Wave f=', num2str(f), 'Hz']);


fs=500; %sampling frequency
T=0.2; %width of the rectangule pulse in seconds
t=-0.5:1/fs:0.5; %time base
g=(t >-T/2) .* (t<T/2) + 0.5*(t==T/2) + 0.5*(t==-T/2);
%g=rectpuls(t,T); %using inbuilt function (signal proc toolbox)
figure(3); plot(t,g);title(['Rectangular Pulse width=', num2str(T),'s']);


fs=80; %sampling frequency
sigma=0.1;%standard deviation
t=-0.5:1/fs:0.5; %time base
g=1/(sqrt(2*pi)*sigma)*(exp(-t.^2/(2*sigma^2)));
figure(4); plot(t,g); title(['Gaussian Pulse \sigma=', num2str(sigma),'s']);


function g=chirp_signal(t,f0,t1,f1,phase)
%g = chirp_signal(t,f0,t1,f1) generates samples of a linearly
%swept-frequency signal at the time instances defined in timebase
%array t.  The instantaneous frequency at time 0 is f0 Hertz.
%The instantaneous frequency f1 is achieved at time t1. The argument
%'phase' is optional. It defines the initial phase of the signal
%defined in radians. By default phase=0 radian
if nargin==4, phase=0; end
t0=t(1); T=t1-t0; k=(f1-f0)/T;
g=cos(2*pi*(k/2*t+f0).*t+phase);
end

fs=500; %sampling frequency
t=0:1/fs:1; %time base - upto 1 second
f0=1;% starting frequency of the chirp
f1=fs/20; %frequency of the chirp at t1=1 second
g = chirp_signal(t,f0,1,f1);
figure(5); plot(t,g); title('Chirp Signal');


