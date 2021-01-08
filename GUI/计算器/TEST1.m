function varargout = TEST1(varargin)
% TEST1 MATLAB code for TEST1.fig
%      TEST1, by itself, creates a new TEST1 or raises the existing
%      singleton*.
%
%      H = TEST1 returns the handle to a new TEST1 or the handle to
%      the existing singleton*.
%
%      TEST1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST1.M with the given input arguments.
%
%      TEST1('Property','Value',...) creates a new TEST1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TEST1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TEST1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TEST1

% Last Modified by GUIDE v2.5 18-Jul-2020 02:07:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TEST1_OpeningFcn, ...
                   'gui_OutputFcn',  @TEST1_OutputFcn, ...
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


% --- Executes just before TEST1 is made visible.
function TEST1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TEST1 (see VARARGIN)

% Choose default command line output for TEST1
handles.output = hObject;

% Update handles structure  更新
guidata(hObject, handles);

% UIWAIT makes TEST1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TEST1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sz1_Callback(hObject, eventdata, handles)
% hObject    handle to sz1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sz1 as text
%        str2double(get(hObject,'String')) returns contents of sz1 as a double


% --- Executes during object creation, after setting all properties.
function sz1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sz1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sz2_Callback(hObject, eventdata, handles)
% hObject    handle to sz2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sz2 as text
%        str2double(get(hObject,'String')) returns contents of sz2 as a double


% --- Executes during object creation, after setting all properties.
function sz2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sz2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function jg_Callback(hObject, eventdata, handles)
% hObject    handle to jg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jg as text
%        str2double(get(hObject,'String')) returns contents of jg as a double
 


% --- Executes during object creation, after setting all properties.
function jg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in caclute.
function caclute_Callback(hObject, eventdata, handles)
% hObject    handle to caclute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num1=str2double(get((handles.sz1),'String')); %可以直接将字符串数字 转化为数字（也可以是矩阵）
num2=str2double(get((handles.sz2),'String'));
r=num1+num2;
r=num2str(r);
set(handles.jg,'String',r);
guidata(hObject, handles);
untitled2;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
b=0;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
