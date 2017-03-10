%%%%%%%%%%%%%%%%%Audio Watermarking Via EMD%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%IEEE 2013 Transactions%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

se=uigetfile('*.wav','please select an wave file');
[A,fs,nbits] = wavread(se);
figure(1); plot(A); 
axis([0 350000 -2 2]);
title('Original Audio Signal');
s = size(A);
wat = imread('watermark.jpg');
b = im2bw(wat);
[M1,M2] = size(b);
M12 = M1*M2; 
C = reshape(b,1,M12);
n = M12*2;
M = zeros(n,1);
for k = 1 : n
    if mod(k,4) == 0
        M(k) = 1;
    else 
        M(k) = 0;
    end
    l = ceil(k/2);
    S(k) = bitxor(C(l),M(k));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 10; 
length = n*10;
i = 1 : length; 
j = [1];
Ae = A(i,j);
% Ae(i,j)
i = length+1 : s;
Ar = A(i,j);
k = 1;
B = cell(n,1);
th = n*N;
while ( k < th )
    i = k : k+9;
    m = (k+9)/10;
    B{m,1} = Ae(i,j);
    k = k+10;
end
time=0.5;

D = cell(n,1);

for i = 1 : n
    
    %D{i,1} = dct(B{i,1});
    [D{i,1}]=emd(B{i,1},time);

end
figure(2)
subplot(4,1,1);plot(D{1,1});title('IMF1');
subplot(4,1,2);plot(D{2,1});title('IMF2');
subplot(4,1,3);plot(D{3,1});title('IMF3');
subplot(4,1,4);plot(D{4,1});title('IMF4');

E = cell(n,1);
E = D;
for i = 1 : n

     E{i,1}(3) = (D{i,1}(3))*(1+2*S(i));
end
F = cell(n,1);

for i = 1 : n
    F{i,1} = idct(E{i,1});
end


G = F{1,1};

for i = 2 : n
    
    G=[G; F{i,1}];
end

G =[G; Ar];
wavwrite(G,fs,nbits,'test.wav');
figure(3); plot(G); 
title('Watermarked Audio');
axis([0 350000 -2 2]);




