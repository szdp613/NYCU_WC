function y = conv_brute_force(x,h)
%Brute force method to compute convolution

N=length(x); M=length(h);
y = zeros(1,N+M-1);
for i = 1:N,
   for j = 1:M,
       y(i+j-1) = y(i+j-1) + x(i) * h(j);
   end
end
end

function [H]=convMatrix(h,p)
%Construct the convolution matrix of size (N+p-1)x p from the input
%matrix h of size N.
 h=h(:).';
 col=[h zeros(1,p-1)]; row=[h(1) zeros(1,p-1)];
 H=toeplitz(col,row);
end

function [y]=convolve(h,x)
%Convolve two sequences h and x of arbitrary lengths:  y=h*x
    H=convMatrix(h,length(x)); %see convMatrix.m
    y=H*x.';  %equivalent to conv(h,x) inbuilt function
end

x=randn(1,7)+1i*randn(1,7) %Create random vectors for test
h=randn(1,3)+1i*randn(1,3) %Create random vectors for test

L=length(x)+length(h)-1; %length of convolution output

y1=convolve(h,x) %Convolution Using Toeplitz matrix
y2=ifft(fft(x,L).*(fft(h,L))).' %Convolution using FFT
y3=conv(h,x) %Matlab's standard function
