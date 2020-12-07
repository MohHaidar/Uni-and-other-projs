function varargout = Capture(varargin)
% CAPTURE MATLAB code for Capture.fig
%      CAPTURE, by itself, creates a new CAPTURE or raises the existing
%      singleton*.
%
%      H = CAPTURE returns the handle to a new CAPTURE or the handle to
%      the existing singleton*.
%
%      CAPTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPTURE.M with the given input arguments.
%
%      CAPTURE('Property','Value',...) creates a new CAPTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Capture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Capture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Capture

% Last Modified by GUIDE v2.5 08-Oct-2016 14:10:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Capture_OpeningFcn, ...
                   'gui_OutputFcn',  @Capture_OutputFcn, ...
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


% --- Executes just before Capture is made visible.
function Capture_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Capture (see VARARGIN)

% Choose default command line output for Capture
handles.output = hObject;

global depthDevice;
global colorDevice;
%release(colorDevice);
%release(depthDevice);
colorDevice = imaq.VideoDevice('kinect',1);
depthDevice = imaq.VideoDevice('kinect',2);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Capture wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Capture_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global colorDevice;
global depthDevice;

varargout{1} = handles.output;
%release(colorDevice);
%release(depthDevice);


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ptCloud;
[file,path]=uigetfile('*.ply');
ptCloud = pcread([path file]);
ptCloud = pointCloud(ptCloud.Location);
mat=ptCloud.Location;
%mat=medfilt1(mat,3);
ptCloud=pointCloud(mat);
axes(handles.axes1);
pcshow(ptCloud);
view(15,-80);
% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ptCloud;
[file,path]=uiputfile('*.ply');
pcwrite(ptCloud,[path file]);

% --- Executes on button press in capture.
function capture_Callback(hObject, eventdata, handles)
% hObject    handle to capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global depthDevice;
global colorDevice;
global ptCloud;
colorImage = step(colorDevice);
depthImage = step(depthDevice);

ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);
ptCloud = pcmerge(ptCloud, ptCloud, 0.00001);
ptCloud = pointCloud(ptCloud.Location);
axes(handles.axes1);
pcshow(ptCloud);
view(15,-80);
% --- Executes on button press in merge.
function merge_Callback(hObject, eventdata, handles)
% hObject    handle to merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ptCloud;

[file1,path1]=uigetfile('*.ply','Select fixed cloud');
ptCloud1 = pcread([path1 file1]);

[file2,path2]=uigetfile('*.ply','Select merging file');
ptCloud2 = pcread([path2 file2]);

gridSize = 0.1;
fixed = pcdownsample(ptCloud1, 'gridAverage', gridSize);
moving = pcdownsample(ptCloud2, 'gridAverage', gridSize);
fixed = pcdenoise(fixed);
moving = pcdenoise(moving);
tform = pcregrigid(moving, fixed, 'Metric','pointToPoint','Extrapolate', false);

ptCloudAligned = pctransform(ptCloud2,tform);

mergeSize = 0.0001;
ptCloud = pcmerge(ptCloud1, ptCloudAligned, mergeSize);
axes(handles.axes1);
pcshow(ptCloud);
view(15,-80);

% --- Executes on button press in crop.
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ptCloud;
prompt = {'Xmin','Xmax','Ymin','Ymax','Zmin','Zmax'};
Limit=inputdlg(prompt,'Specify dimentios',1);
[Xmin,Xmax,Ymin,Ymax,Zmin,Zmax]=Limit{:};

mat=ptCloud.Location;

bac= mat(:,3)>str2double(Zmax);
mat(bac,:)=0;

bac= mat(:,3)<str2double(Zmin);
mat(bac,:)=0;

bac= mat(:,2)>str2double(Ymax);
mat(bac,:)=0;

bac= mat(:,2)<str2double(Ymin);
mat(bac,:)=0;

bac= mat(:,1)>str2double(Xmax);
mat(bac,:)=0;

bac= mat(:,1)<str2double(Xmin);
mat(bac,:)=0;

ptCloud = pointCloud(mat);

axes(handles.axes1);
pcshow(ptCloud);
view(15,-80);


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global colorDevice;
global depthDevice;
%release(colorDevice);
%release(depthDevice);
close;
