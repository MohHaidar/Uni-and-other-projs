function varargout = Test(varargin)
% TEST MATLAB code for Test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test

% Last Modified by GUIDE v2.5 27-Nov-2016 22:07:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Test_OpeningFcn, ...
                   'gui_OutputFcn',  @Test_OutputFcn, ...
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


% --- Executes just before Test is made visible.
function Test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test (see VARARGIN)

% Choose default command line output for Test
handles.output = hObject;

% Initiate variables for mfcc
%           Tw = 25;           % analysis frame duration (ms)
%           Ts = 10;           % analysis frame shift (ms)
%           alpha = 0.97;      % preemphasis coefficient
%           R = [ 300 3700 ];  % frequency range to consider
%           M = 20;            % number of filterbank channels 
%           C = 13;            % number of cepstral coefficients
%           L = 22;            % cepstral sine lifter parameter
%       
%           % hamming window (see Eq. (5.2) on p.73 of [1])
%           hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
%               [1] Young, S., Evermann, G., Gales, M., Hain, T., Kershaw, D., 
%               Liu, X., Moore, G., Odell, J., Ollason, D., Povey, D., 
%               Valtchev, V., Woodland, P., 2006. The HTK Book (for HTK 
%               Version 3.4.1). Engineering Department, Cambridge University.
%               (see also: http://htk.eng.cam.ac.uk)
global Tw;
global Ts;
global alpha;
global R;
global M;
global C;
global L;
global hamming;
global G_coeff;
Tw = 25; 
Ts = 10;
alpha = 0.97;
R = [ 30 3700 ];
M = 20;
C = 13;
L = 22;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
G_coeff = 16;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in AddData.
function AddData_Callback(hObject, eventdata, handles)
% hObject    handle to AddData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Global parameters for mfcc and GMM
global Tw;
global Ts;
global alpha;
global R;
global M;
global C;
global L;
global hamming;
global G_coeff;

% Browse files

[files,path]=uigetfile('*.wav','MultiSelect','on');
if (path~=0)
files = cellstr(files);
Nb = numel(files);
if exist('test.mat','file') ~= 2
    % Initiate database with rows labels
    Database = {'label';'Samples'};
    save('test.mat','Database');
end
stop = 0;
% Scan every file in the file list
for i = 1:Nb 
    load('test.mat');
    PersonDb = cell2struct(Database,{'label','Samples'},1);
    file = char(files(i));
    
    % Ask for speaker name
    label = char(inputdlg(strcat('Enter the name of the person speaking in:',file),'Label',[1 25])); 
    if(strcmp(label,''))
        %
        % in case of empty name or cancel
        %
        stop=1;
        break;
    end
    % Scan database names
    names=cellstr(PersonDb(1).label);
    for j=2:numel(PersonDb)
        name = cellstr(PersonDb(j).label);
        names = [ names , name ];
    end
    index = find(strcmpi(label,names),1);
    if(~isempty(index))
        % if the name is found keep asking until they chose a new name or accept to keep the file under same name
    choice = questdlg('This name already exists in the database, save this voice under the same name ?','Name exists',...
    'Yes','No','Yes');   
    end
    while(~isempty(index)&&strcmp(choice,'No'))
     
    label = char(inputdlg(strcat('Enter the name of the person speaking in:',file),'Label',[1 25]));
    if(strcmp(label,''))
        stop=1;
        break;
    end
    names=cellstr(PersonDb(1).label);
    for j=2:numel(PersonDb)
        name = cellstr(PersonDb(j).label);
        names = [ names , name ];
    end
    index = find(strcmpi(label,names),1);  
     if(~isempty(index))
    choice = questdlg('This name already exists in the database, save this voice under the same name ?','Name exists',...
    'Yes','No','Yes');   
    end
    end
    % end of while
    if(stop==1)
        break;
    end
    [voice,Fs] = audioread(char(strcat(path,file)));
    [ MFCCs, ~, ~ ] = mfcc( voice, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
    %[ Cepst.m,Cepst.v,Cepst.w ]=gaussmix(MFCCs',[],[],G_coeff,'v');
    [ m,v,w ]=gaussmix(MFCCs',[],[],G_coeff);
    index = find(strcmpi(label,names),1);
    if(isempty(index))
        Person.label=label;
        Person.Samples.Cepst.m=m;
        Person.Samples.Cepst.v=v;
        Person.Samples.Cepst.w=w;
        Person.Samples.audio=voice;
        Person.Samples.file=file;
        Person.Samples.Create_date=datestr(datetime('now'));
    PersonDb = [PersonDb;Person];
    
    else
     Samples_nb = numel(PersonDb(index).Samples);  
     PersonDb(index).Samples(Samples_nb+1).Cepst.m=m;
     PersonDb(index).Samples(Samples_nb+1).Cepst.v=v;
     PersonDb(index).Samples(Samples_nb+1).Cepst.w=w;
     PersonDb(index).Samples(Samples_nb+1).audio=voice;
     PersonDb(index).Samples(Samples_nb+1).file=file;
     PersonDb(index).Samples(Samples_nb+1).Create_date=datestr(datetime('now'));
    end
    Database = struct2cell(PersonDb);
    save('test.mat','Database','-append');
end
if(stop==1)
    msgbox('Data entry interrupted');
end
msgbox('Database updated!');
end

% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Tw;
global Ts;
global alpha;
global R;
global M;
global C;
global L;
global hamming;
global G_coeff;
[file,path]=uigetfile('*.wav');
[voice,Fs] = audioread(char(strcat(path,file)));
[ MFCCs, ~, ~ ] = mfcc( voice, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
%[ m,v,w ]=gaussmix(MFCCs',[],[],G_coeff,'v');
[ m,v,w ]=gaussmix(MFCCs',[],[],G_coeff);
load('test.mat');
PersonDb = cell2struct(Database,{'label','Samples'},1);
%results = zeros(numel(CepstDb)-1,1);
file = fopen('results.txt', 'wt');
for i = 2:numel(PersonDb) 
    for j=1:numel(PersonDb(i).Samples)
[result,~]=gaussmixk(m,v,w,PersonDb(i).Samples(j).Cepst.m,PersonDb(i).Samples(j).Cepst.v,PersonDb(i).Samples(j).Cepst.w); 
fprintf(file,'%s%d\t',PersonDb(i).label,j);
fprintf(file,'\t%s\n',result);
    end
end    
fclose(file);                     
winopen('results.txt')


% --- Executes on button press in Identify.
function Identify_Callback(hObject, eventdata, handles)
% hObject    handle to Identify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Tw;
global Ts;
global alpha;
global R;
global M;
global C;
global L;
global hamming;
global G_coeff;
[file,path]=uigetfile('*.wav');
[voice,Fs] = audioread(char(strcat(path,file)));
[ MFCCs, ~, ~ ] = mfcc( voice, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
%[ m,v,w ]=gaussmix(MFCCs',[],[],G_coeff,'v');
[ m,v,w ]=gaussmix(MFCCs',[],[],G_coeff);
load('test.mat');
PersonDb = cell2struct(Database,{'label','Samples'},1);
results = [];
for i = 2:numel(PersonDb) 
    Person_result=[];
    for j=1:numel(PersonDb(i).Samples)        
        [Person_result(j),~]=gaussmixk(m,v,w,PersonDb(i).Samples(j).Cepst.m,PersonDb(i).Samples(j).Cepst.v,PersonDb(i).Samples(j).Cepst.w);      
    end
    results(i-1) = mean(Person_result);
end    
[min_dist,idx] = min(results);
threshold = 8;
if(min_dist<=threshold)
set(handles.name,'String',PersonDb(idx+1).label);
else
msgbox('Person not recognized!');   
end
