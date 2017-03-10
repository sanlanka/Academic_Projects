function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 01-Oct-2013 03:45:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

se=uigetfile('*.wav','please select an wave file');

[A,fs,nbits] = wavread(se);

%audioplayer(A,fs,nbits);
%sound(A,fs);
figure(1); plot(A); 
axis([0 350000 -2 2]);
title('Original Audio Signal');
s = size(A);
save s ,save A

% --- Executes on button press in pushbutton3.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

wat = imread('watermark.jpg');
wat=imresize(wat,[84 84]);
figure(2),imshow(wat),title('Watermark Logo');
save wat

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load wat,load A
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
save E{i,1},save n,save b
helpdlg('Embedding Process Completed');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load n ,load E{i,1} 
time=0.5;
F = cell(n,1);

for i = 1 : n
    F{i,1} = iemd(E{i,1},time);
end


G = F{1,1};

for i = 2 : n
    
    G=[G; F{i,1}];
end

G =[G; Ar];
wavwrite(G,fs,nbits,'test.wav');
save G
helpdlg('Inverse EMD Completed');
% --- Executes on button press in pushbutton7.

function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load G
figure(4); plot(G); 
title('Watermarked Audio');
axis([0 350000 -2 2]);

%wavplay(G);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[T,fs,nbits] = wavread('test.wav');
figure(5); plot(T); 
axis([0 350000 -2 2]);
title('Watermarked Audio Signal');
s = size(T);
save s ,save T

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load A,load b,load T
[r,c] = size(b);
M1 = r; M2 = c;
N = 10; 
M12 = M1*M2; 
n = M12*2;
length = n*10;
L=size(A);
i = 1 : length; 
j = [1];

Ae = A(i,j);
Te = T(i,j);
i = length+1 : L;

Ar = A(i,j);
Tr = T(i,j);


k = 1;

B = cell(n,1);
Bt = cell(n,1);
th = n*N;

while ( k < th )
    i = k : k+9;
    m = (k+9)/10;
    B{m,1} = Ae(i,j);
    Bt{m,1} = Te(i,j);
    k = k+10;
end


D = cell(n,1);
Dt = cell(n,1);
for i = 1 : n
    
    D{i,1} = emd(B{i,1});
    Dt{i,1} = emd(Bt{i,1});
end

C = zeros(1,n);
for i = 1 : n
    th1 = abs(Dt{i,1}(3)/D{i,1}(3));
    if th1 < 2.0
        C(i) = 0;
    else C(i) = 1;
    end
end
M = zeros(n,1);
for k = 1 : n
    if mod(k,4) == 0
        M(k) = 1;
    else 
        M(k) = 0;
    end
    l = ceil(k/2);
    S(l) = bitxor(C(k),M(k));
end

for j = 1 : M2
    for i = 1 : M1
        n = (j-1)*M1+i;
        Im(i,j) = S(n);
    end
end

helpdlg('Extration Completed');
save Im
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Im
figure(6),imshow(Im);title('Extracted Logo');

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load T,load A,load b
y = awgn(T,10,'measured'); 
figure(7),plot(y);
axis([0 350000 -2 2]);
[r,c] = size(b);
M1 = r; M2 = c;
N = 10; 
M12 = M1*M2; 
n = M12*2;
length = n*10;
L=size(A);
i = 1 : length; 
j = [1];

Ae = A(i,j);
Te = T(i,j);
i = length+1 : L;

Ar = A(i,j);
Tr = T(i,j);


k = 1;

B = cell(n,1);
Bt = cell(n,1);
th = n*N;

while ( k < th )
    i = k : k+9;
    m = (k+9)/10;
    B{m,1} = Ae(i,j);
    Bt{m,1} = Te(i,j);
    k = k+10;
end


D = cell(n,1);
Dt = cell(n,1);
for i = 1 : n
    
    D{i,1} = emd(B{i,1});
    Dt{i,1} = emd(Bt{i,1});
end

C = zeros(1,n);
for i = 1 : n
    th1 = abs(Dt{i,1}(3)/D{i,1}(3));
    if th1 < 2.0
        C(i) = 0;
    else C(i) = 1;
    end
end
M = zeros(n,1);
for k = 1 : n
    if mod(k,4) == 0
        M(k) = 1;
    else 
        M(k) = 0;
    end
    l = ceil(k/2);
    S(l) = bitxor(C(k),M(k));
end

for j = 1 : M2
    for i = 1 : M1
        n = (j-1)*M1+i;
        Im(i,j) = S(n);
    end
end
figure(7),imshow(Im);title('Extracted Logo after Attacks');
