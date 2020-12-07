function varargout = decode(varargin)
% DECODE MATLAB code for decode.fig
%      DECODE, by itself, creates a new DECODE or raises the existing
%      singleton*.
%
%      H = DECODE returns the handle to a new DECODE or the handle to
%      the existing singleton*.
%
%      DECODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECODE.M with the given input arguments.
%
%      DECODE('Property','Value',...) creates a new DECODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before decode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to decode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help decode

% Last Modified by GUIDE v2.5 04-Jul-2016 01:57:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @decode_OpeningFcn, ...
                   'gui_OutputFcn',  @decode_OutputFcn, ...
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


% --- Executes just before decode is made visible.
function decode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to decode (see VARARGIN)

% Choose default command line output for decode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
k=getappdata(0,'key');
if ~k==0
set(handles.key,'String',reshape(dec2hex(k)',1,32));
end

% UIWAIT makes decode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = decode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in decode.
function decode_Callback(hObject, eventdata, handles)
% hObject    handle to decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fs=getappdata(0,'Fs');
stereo=getappdata(0,'stereo');
Rmsg=getappdata(0,'msg');
Rmsg=reshape(Rmsg',8,16)';
k=get(handles.key,'String');
k=hex2dec(cell2mat(cellstr(reshape(k,2,16)')))';
M=zeros(8,16);
% if you want to change the message length change the factor variable in 
% encode and decode for 128-bits factor=8, for 64 bits factor=4, for
% 32 bits factor=2, for 16 bits factor=1
factor=8;
if(stereo==1)
    factor=factor/2;
    A1=getappdata(0,'A1');
    A2=getappdata(0,'A2');
    %[~,body1,~]=decomp(A1);
    %[~,body2,~]=decomp(A2);
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
        M(2*i-1,:)=Mdecode5(fft(T1(:,i)),k,Fs); 
        M(2*i,:)=Mdecode5(fft(T2(:,i)),k,Fs);
    end
else
    A1=getappdata(0,'A1');
    %[~,body1,~]=decomp(A1);
    %N1=length(body1);
    N1=length(A1);
    N1=N1-mod(N1,factor);
    T1=zeros(N1/factor,factor);
    for i=1:factor
        %T1(:,i)=body1((i-1)*(N1/8)+1:i*(N1/8));
        T1(:,i)=A1((i-1)*(N1/factor)+1:i*(N1/factor));
        M(i,:)=Mdecode5(fft(T1(:,i)),k,Fs); 
    end
end
msg=reshape(M',8,16)';
set(handles.msg,'String',char(bi2de(msg))');
Nb_error_bits=length(find(xor(Rmsg,msg)));
Taux=Nb_error_bits/128;
set(handles.error,'String',Taux);

