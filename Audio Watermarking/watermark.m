function varargout = watermark(varargin)
% WATERMARK MATLAB code for watermark.fig
%      WATERMARK, by itself, creates a new WATERMARK or raises the existing
%      singleton*.
%
%      H = WATERMARK returns the handle to a new WATERMARK or the handle to
%      the existing singleton*.
%
%      WATERMARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARK.M with the given input arguments.
%
%      WATERMARK('Property','Value',...) creates a new WATERMARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before watermark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to watermark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help watermark

% Last Modified by GUIDE v2.5 05-Jul-2016 04:07:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermark_OpeningFcn, ...
                   'gui_OutputFcn',  @watermark_OutputFcn, ...
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


% --- Executes just before watermark is made visible.
function watermark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to watermark (see VARARGIN)

% Choose default command line output for watermark
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global k;
k=0;

% UIWAIT makes watermark wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = watermark_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
appdata = get(0,'ApplicationData');
fns = fieldnames(appdata);
for ii = 1:numel(fns)
  rmappdata(0,fns{ii});
end
varargout{1} = handles.output;


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
appdata = get(0,'ApplicationData');
fns = fieldnames(appdata);
for ii = 1:numel(fns)
  rmappdata(0,fns{ii});
end
[file,path]=uigetfile('*.wav');
set(handles.text1,'String',[path file]);
global Fs;
global N;
[Audio,Fs]=audioread([path file]);
N=length(Audio);
global stereo;
stereo=0;
global A1;
global A2;
if(length(Audio(1,:))>1)
    A1=Audio(:,1);
    A2=Audio(:,2);
    stereo=1;
else 
    A1=Audio;
end
axes(handles.axes1);
plot(1/Fs*(0:N-1),A1);
grid on;
axes(handles.axes2);
semilogx(Fs/N*(0:N-1),abs(fft(A1)));
grid on;


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs;
global A1;
global A2;
global stereo;
global ply;
if(stereo==1)
   ply=audioplayer([A1 A2],Fs);
else
   ply=audioplayer(A1,Fs); 
end
play(ply);
set(handles.stop, 'Visible', 'On');
set(handles.play, 'Visible', 'Off');


% --- Executes on button press in encode.
function encode_Callback(hObject, eventdata, handles)
% hObject    handle to encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stereo;
global A1;
global A2;
global Fs;
global k;
global M;
global factor;
setappdata(0,'stereo',stereo);
setappdata(0,'Fs',Fs);
setappdata(0,'A1',A1);
if(stereo==1)
    setappdata(0,'A2',A2);
end
encode_handle=encode;
uiwait(gcf); 
factor=getappdata(0,'factor');
k=getappdata(0,'key');
M=getappdata(0,'msg');
A1=getappdata(0,'A1');
if(stereo==1)
    A2=getappdata(0,'A2');
end
N=length(A1);
axes(handles.axes1);
plot(1/Fs*(0:N-1),A1);
grid on;
axes(handles.axes2);
semilogx(Fs/N*(0:N-1),abs(fft(A1)));
grid on;

    

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1;
global A2;
global stereo;
global Fs;
[file,path] = uiputfile('*.wav');
if(stereo==1)
    Audiowrite([path file],[A1 A2],Fs);
else
    Audiowrite([path file],A1,Fs);
end


% --- Executes on button press in attack.
function attack_Callback(hObject, eventdata, handles)
% hObject    handle to attack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stereo;
global A1;
global A2;
global oA1;
global oA2;
global Fs;
setappdata(0,'stereo',stereo);
setappdata(0,'A1',A1);
oA1=A1;
if stereo==1
    setappdata(0,'A2',A2);
    oA2=A2;
end
FILT_handle=filt;
uiwait(gcf); 
A1=getappdata(0,'A1');
if stereo==1
    A2=getappdata(0,'A2');
end
N=length(A1);
axes(handles.axes1);
plot(1/Fs*(0:N-1),A1);
grid on;
axes(handles.axes2);
semilogx(Fs/N*(0:N-1),abs(fft(A1)));
grid on;




% --- Executes on button press in decode.
function decode_Callback(hObject, eventdata, handles)
% hObject    handle to decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stereo;
global A1;
global A2;
global Fs;
global k;
global M;
global factor;
setappdata(0,'factor',factor);
setappdata(0,'stereo',stereo);
setappdata(0,'Fs',Fs);
setappdata(0,'A1',A1);
setappdata(0,'msg',M);
setappdata(0,'key',k);
if(stereo==1)
    setappdata(0,'A2',A2);
end
decode_handle=decode;
uiwait(gcf); 


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ply;
stop(ply);
set(handles.stop, 'Visible', 'Off');
set(handles.play, 'Visible', 'On');


% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stereo;
global A1;
global A2;
global oA1;
global oA2;
global Fs;
A1=oA1;
if stereo==1
A2=oA2;
end
N=length(A1);
axes(handles.axes1);
plot(1/Fs*(0:N-1),A1);
grid on;
axes(handles.axes2);
semilogx(Fs/N*(0:N-1),abs(fft(A1)));
grid on;
