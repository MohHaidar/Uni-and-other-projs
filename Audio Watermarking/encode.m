function varargout = encode(varargin)
% ENCODE MATLAB code for encode.fig
%      ENCODE, by itself, creates a new ENCODE or raises the existing
%      singleton*.
%
%      H = ENCODE returns the handle to a new ENCODE or the handle to
%      the existing singleton*.
%
%      ENCODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENCODE.M with the given input arguments.
%
%      ENCODE('Property','Value',...) creates a new ENCODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before encode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to encode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help encode

% Last Modified by GUIDE v2.5 04-Jul-2016 03:26:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @encode_OpeningFcn, ...
                   'gui_OutputFcn',  @encode_OutputFcn, ...
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


% --- Executes just before encode is made visible.
function encode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to encode (see VARARGIN)

% Choose default command line output for encode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes encode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = encode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function msg_Callback(hObject, eventdata, handles)
% hObject    handle to msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msg as text
%        str2double(get(hObject,'String')) returns contents of msg as a double
global msg;
msg=get(handles.msg,'String');

% --- Executes during object creation, after setting all properties.
function msg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in keygen.
function keygen_Callback(hObject, eventdata, handles)
% hObject    handle to keygen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global k;
k=randperm(30,16);
set(handles.key,'String',reshape(dec2hex(k)',1,32));

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global msg;
global k;

k=get(handles.key,'String');
k=hex2dec(cell2mat(cellstr(reshape(k,2,16)')))';
Fs=getappdata(0,'Fs');
stereo=getappdata(0,'stereo');
ascii=double(msg);
%size=length(ascii);
%factor=floor((size+1)/2);
binary=de2bi(ascii,8);
binary=reshape(binary',1,[]);
z=zeros(1,128-length(binary));
M=[binary z];
M=reshape(M,16,8);
M=M';
% if you want to change the message length change the factor variable in 
% encode and decode for 128-bits factor=8, for 64 bits factor=4, for
% 32 bits factor=2, for 16 bits factor=1
factor=8;

if(stereo==1)
    factor=factor/2;
    A1=getappdata(0,'A1');
    A2=getappdata(0,'A2');
    %[head1,body1,tail1]=decomp(A1);
    %[head2,body2,tail2]=decomp(A2);
    %N1=length(body1);
    %N2=length(body2);
    N1=length(A1);
    N2=length(A2);
    N1=N1-mod(N1,factor);
    N2=N2-mod(N2,factor);
    T1=zeros(N1/factor,factor);
    T2=zeros(N2/factor,factor);
    for i=1:factor
        %T1(:,i)=body1((i-1)*(N1/4)+1:i*(N1/4));
        %T2(:,i)=body2((i-1)*(N2/4)+1:i*(N2/4));
        T1(:,i)=A1((i-1)*(N1/factor)+1:i*(N1/factor));
        T2(:,i)=A2((i-1)*(N2/factor)+1:i*(N2/factor));
        T1(:,i)=ifft(Mencode5(fft(T1(:,i)),M(2*i-1,:),k,Fs)); 
        T2(:,i)=ifft(Mencode5(fft(T2(:,i)),M(2*i,:),k,Fs));
    end
    T1=reshape(T1,N1,1);
    T2=reshape(T2,N2,1);
    %A1=[head1;T1;tail1];
    %A2=[head2;T2;tail2];
    A1=T1;
    A2=T2;
    N1=length(A1);
    N2=length(A2);
    diff=max(N1,N2)-min(N1,N2);
    if(N1>N2)
        A1=A1(1:N1-diff);
    end
    if(N2>N1)
        A2=A2(1:N2-diff);
    end
    setappdata(0,'A1',A1);
    setappdata(0,'A2',A2);
else
    A1=getappdata(0,'A1');
    %[head1,body1,tail1]=decomp(A1);
    %N1=length(body1);
    N1=length(A1);
    N1=N1-mod(N1,factor);
    T1=zeros(N1/factor,factor);
    for i=1:factor
        %T1(:,i)=body1((i-1)*(N1/8)+1:i*(N1/8));
        T1(:,i)=A1((i-1)*(N1/factor)+1:i*(N1/factor));
        T1(:,i)=ifft(Mencode5(fft(T1(:,i)),M(i,:),k,Fs)); 
    end
    T1=reshape(T1,N1,1);
    %A1=[head1;T1;tail1];
    A1=T1;
    setappdata(0,'A1',A1);
end
setappdata(0,'key',k);
setappdata(0,'msg',M);

delete(get(hObject, 'parent'));


function key_Callback(hObject, eventdata, handles)
% hObject    handle to key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of key as text
%        str2double(get(hObject,'String')) returns contents of key as a double


% --- Executes during object creation, after setting all properties.
function key_CreateFcn(hObject, eventdata, handles)
% hObject    handle to key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
