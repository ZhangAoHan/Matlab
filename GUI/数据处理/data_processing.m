function varargout = data_processing(varargin)
% DATA_PROCESSING MATLAB code for data_processing.fig
%      DATA_PROCESSING, by itself, creates a new DATA_PROCESSING or raises the existing
%      singleton*.
%
%      H = DATA_PROCESSING returns the handle to a new DATA_PROCESSING or the handle to
%      the existing singleton*.
%
%      DATA_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PROCESSING.M with the given input arguments.
%
%      DATA_PROCESSING('Property','Value',...) creates a new DATA_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_processing

% Last Modified by GUIDE v2.5 13-Jul-2020 23:17:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_processing_OpeningFcn, ...
                   'gui_OutputFcn',  @data_processing_OutputFcn, ...
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


% --- Executes just before data_processing is made visible.
function data_processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_processing (see VARARGIN)

% Choose default command line output for data_processing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%定义全局变量
global file_data;     %读取.mat文件中的数据
% --- Outputs from this function are returned to the command line.
function varargout = data_processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Data_decomposition_Callback(hObject, eventdata, handles)
% hObject    handle to Data_decomposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Data_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Data_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Mapping_resule_Callback(hObject, eventdata, handles)
% hObject    handle to Mapping_resule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in open_data.
function open_data_Callback(hObject, eventdata, handles)
% hObject    handle to open_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file_data;     %读取.mat文件中的数据
[filename,pathname]=uigetfile('*.mat','打开数据文件');
path_name=[pathname,filename];
set(handles.daya_file,'String',path_name);  %显示文件路径及名字
copyfile(path_name,'F:\工程文件\Matlab\GUI\数据处理\test.mat');
load test;  %需要保证原.mat文件中变量名为y 否则需要修改
file_data=y;
% figure
% plot(file_data)  %画出原始信号图像
% y1=load('F:\工程文件\Matlab\GUI\数据处理\test.mat');
% save test.mat y1;
% file_data=load('F:\工程文件\Matlab\GUI\数据处理\test.mat');
% file_data=file_data.y1;
% figure(1)

function fs_data_Callback(hObject, eventdata, handles)
% hObject    handle to fs_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs_data as text
%        str2double(get(hObject,'String')) returns contents of fs_data as a double


% --- Executes during object creation, after setting all properties.
function fs_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file_data;     %读取.mat文件中的数据
data_fs=str2double(get((handles.fs_data),'String'));

if data_fs==0
    
else
    if get(handles.SSD,'value')
        figure  %画原始信号图像
        plot(file_data);
        ssc=SAM_SSD(file_data,data_fs);
        [~,~]= SA_FFT(ssc,data_fs,'draw');
    end
end



function times2_Callback(hObject, eventdata, handles)
% hObject    handle to times2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of times2 as text
%        str2double(get(hObject,'String')) returns contents of times2 as a double
num=str2double(get((handles.times2_data),'String'));
data_times2=num2str(num);

% --- Executes during object creation, after setting all properties.
function times2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to times2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t=1:1000;
y=5*t;
plot(t,y)
