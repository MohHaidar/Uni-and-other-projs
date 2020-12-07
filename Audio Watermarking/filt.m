function varargout = filt(varargin)
% FILT MATLAB code for filt.fig
%      FILT, by itself, creates a new FILT or raises the existing
%      singleton*.
%
%      H = FILT returns the handle to a new FILT or the handle to
%      the existing singleton*.
%
%      FILT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILT.M with the given input arguments.
%
%      FILT('Property','Value',...) creates a new FILT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filt

% Last Modified by GUIDE v2.5 04-Jul-2016 04:46:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filt_OpeningFcn, ...
                   'gui_OutputFcn',  @filt_OutputFcn, ...
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


% --- Executes just before filt is made visible.
function filt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filt (see VARARGIN)

% Choose default command line output for filt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filt wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global A1;
global A2;
global stereo;
stereo=getappdata(0,'stereo');
A1=getappdata(0,'A1');
if stereo==1
A2=getappdata(0,'A2');
end


% --- Outputs from this function are returned to the command line.
function varargout = filt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in butter.
function butter_Callback(hObject, eventdata, handles)
% hObject    handle to butter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1;
global A2;
global stereo;
Fc=inputdlg('Cutoff frequency (Hz)','Freq',[1 25]);
Fc=str2double(cell2mat(Fc));
[b,a]=butter(5,2*Fc/44100,'low');
A1=filter(b,a,A1);
setappdata(0,'A1',A1);
if stereo==1
    A2=filter(b,a,A2);
    setappdata(0,'A2',A2);
end
delete(get(hObject, 'parent'));
% To see the filter plot use fvtool(b,a) in matlab
% after defining [b,a]=butter(5,2*Fc/44100,'low');
% where Fc is the cutoff frequency

% --- Executes on button press in cheby.
function cheby_Callback(hObject, eventdata, handles)
% hObject    handle to cheby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1;
global A2;
global stereo;
Fc=inputdlg('Cutoff frequency (Hz)','Freq',[1 25]);
Fc=str2double(cell2mat(Fc));
ripple=30;
[b,a]=cheby2(5,ripple,2*Fc/44100,'low');
A1=filter(b,a,A1);
setappdata(0,'A1',A1);
if stereo==1
    A2=filter(b,a,A2);
    setappdata(0,'A2',A2);
end
delete(get(hObject, 'parent'));
% To see the filter plot use fvtool(b,a) in matlab
% after defining [b,a]=cheby2(5,30,2*Fc/44100,'low');
% where Fc is the cutoff frequency

% --- Executes on button press in median.
function median_Callback(hObject, eventdata, handles)
% hObject    handle to median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1;
global A2;
global stereo;
n=inputdlg('Filter order','Order',[1 25]);
n=str2double(cell2mat(n));
A1=medfilt1(A1,n);
setappdata(0,'A1',A1);
if stereo==1
    A2=medfilt1(A2,n);
    setappdata(0,'A2',A2);
end
delete(get(hObject, 'parent'));

% --- Executes on button press in compress.
function compress_Callback(hObject, eventdata, handles)
% hObject    handle to compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1;
global A2;
global stereo;
n=inputdlg('Compression order','Order',[1 25]);
n=str2double(cell2mat(n));
A1=compress(A1,n);
setappdata(0,'A1',A1);
if stereo==1
    A2=compress(A2,n);
    setappdata(0,'A2',A2);
end
delete(get(hObject, 'parent'));

% --- Executes on button press in noise.
function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1;
global A2;
global stereo;
S=inputdlg('Signal over Noise ratio','SNR',[1 25]);
S=str2double(cell2mat(S));
A1=awgn(A1,S,'measured');
setappdata(0,'A1',A1);
if stereo==1
    A2=awgn(A2,S,'measured');
    setappdata(0,'A2',A2);
end
delete(get(hObject, 'parent'));