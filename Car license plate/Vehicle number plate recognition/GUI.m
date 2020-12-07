function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 09-Dec-2016 10:37:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in number.
function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic;
global type;
load imgfildata;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
pic=imread([path file]);
[~,cc]=size(pic);
picture=imresize(pic,[300 500]);

if size(picture,3)==3
  %picture=rgb2gray(picture);
  YCBR=rgb2ycbcr(picture);
  picture=YCBR(:,:,1);

  figure;
  imshow(picture)
end
% se=strel('rectangle',[5,5]);
% a=imerode(picture,se);
%figure,imshow(a);
% b=imdilate(a,se);
threshold = graythresh(picture);
pictureb =~im2bw(picture,threshold);
pictureb = bwareaopen(pictureb,30);
figure
imshow(pictureb)
if cc>2000
    picture1=bwareaopen(pictureb,3500);
else
picture1=bwareaopen(pictureb,3000);
end
figure,imshow(picture1)
picture2=pictureb-picture1;
%figure,imshow(picture2)
picture2=bwareaopen(picture2,200);
figure,imshow(picture2)

[L,Ne]=bwlabel(picture2);
propied=regionprops(L,'BoundingBox');
hold on
pause(1)
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

figure
final_output=[];
t=[];
for n=1:Ne
  [r,c] = find(L==n);
  n1=pictureb(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  imshow(n1)
  pause(0.2)
  x=[ ];

totalLetters=size(imgfile,2);

 for k=1:totalLetters
    
    y=corr2(imgfile{1,k},n1);
    x=[x y];
    
 end
 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
 

final_output=[final_output out];
end
end
type=1;
if(size(final_output)<=3)
    picture=YCBR(:,:,3);
    threshold = graythresh(picture);
pictureb =~im2bw(picture,threshold);
pictureb = bwareaopen(pictureb,30);
figure
imshow(pictureb)
if cc>2000
    picture1=bwareaopen(pictureb,3500);
else
picture1=bwareaopen(pictureb,3000);
end
%figure,imshow(picture1)
picture2=pictureb-picture1;
%figure,imshow(picture2)
picture2=bwareaopen(picture2,200);
%figure,imshow(picture2)

[L,Ne]=bwlabel(picture2);
%propied=regionprops(L,'BoundingBox');
%hold on
%pause(1)
%for n=1:size(propied,1)
%  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
%end
%hold off

%figure
final_output=[];
t=[];
for n=1:Ne
  [r,c] = find(L==n);
  n1=pictureb(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  %imshow(n1)
  pause(0.2)
  x=[ ];

totalLetters=size(imgfile,2);

 for k=1:totalLetters
    
    y=corr2(imgfile{1,k},n1);
    x=[x y];
    
 end
 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
 

final_output=[final_output out];
end
end
type=3;
end
set(handles.nb,'String',final_output);
% --- Executes on button press in color.
function color_Callback(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic;
global type;
YCBR=rgb2ycbcr(pic);
  picture=YCBR(:,:,1);
threshold = graythresh(picture);
BW = im2bw(picture,threshold);
figure;
imshow(BW);
BW2 = imfill(BW,'holes');
figure;
imshow(BW2);
BW2 = imclearborder(BW2);
figure;
imshow(BW2);
se = strel('diamond',2);
BW3 = imerode(BW2,se);
BW3 = imerode(BW3,se);
figure;
imshow(BW3);
mask = im2uint8(BW3);
mask = mask/255;


 picture=YCBR(:,:,3);
threshold = graythresh(picture);
BW = im2bw(picture,threshold);
figure;
imshow(BW);
BW2 = imfill(BW,'holes');
%figure;
%imshow(BW2);
BW2 = imclearborder(BW2);
%figure;
%imshow(BW2);
se = strel('diamond',2);
BW3 = imerode(BW2,se);
BW3 = imerode(BW3,se);
%figure;
%imshow(BW3);
mask2 = im2uint8(BW3);
mask2 = mask2/255;

mask=mask+mask2;
mask=mask>0;
mask = im2uint8(mask);
mask = mask/255;

plate = pic;
plate(:,:,1) = plate(:,:,1).*mask; 
plate(:,:,2) = plate(:,:,2).*mask;
plate(:,:,3) = plate(:,:,3).*mask;
figure;
imshow(plate);

RGB = [mean2(nonzeros(plate(:,:,1))) mean2(nonzeros(plate(:,:,2))) mean2(nonzeros(plate(:,:,3)))];
avg = mean(RGB);
ET = sqrt(var(RGB));
if ET > 25
  RGB = (RGB-avg)>0;
  col = color(RGB);
  %display(col)
else
  if avg > 100
  col = color([1 1 1]);
  % display(col)
  else
  col = color([0 0  0]);
   %display(col)
  end
end
set(handles.col,'String',col);

function nb_Callback(hObject, eventdata, handles)
% hObject    handle to nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb as text
%        str2double(get(hObject,'String')) returns contents of nb as a double


% --- Executes during object creation, after setting all properties.
function nb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function col_Callback(hObject, eventdata, handles)
% hObject    handle to col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of col as text
%        str2double(get(hObject,'String')) returns contents of col as a double


% --- Executes during object creation, after setting all properties.
function col_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
