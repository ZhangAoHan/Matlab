function varargout = findimg(varargin)
% FINDIMG MATLAB code for findimg.fig
%      FINDIMG, by itself, creates a new FINDIMG or raises the existing
%      singleton*.
%
%      H = FINDIMG returns the handle to a new FINDIMG or the handle to
%      the existing singleton*.
%
%      FINDIMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDIMG.M with the given input arguments.
%
%      FINDIMG('Property','Value',...) creates a new FINDIMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findimg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findimg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findimg

% Last Modified by GUIDE v2.5 23-Apr-2017 16:06:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @findimg_OpeningFcn, ...
                   'gui_OutputFcn',  @findimg_OutputFcn, ...
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


% --- Executes just before findimg is made visible.
function findimg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findimg (see VARARGIN)

% Choose default command line output for findimg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes findimg wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%定义全局变量
global ButtonDown pos1;
ButtonDown = [];
pos1 = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Outputs from this function are returned to the command line.
function varargout = findimg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
axis([0 250 0 250]);

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)   %手写框 （创建手写框后触发函数）
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
%取消显示axes的坐标轴
set((hObject),'xTick',[]);
set((hObject),'yTick',[]);
% figure(2)
% plot(1:5,[2 3 4 5 6])
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)   %保存图片
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f,p]=uiputfile({'*.jpg'},'保存文件');  %保存所画的图
str=strcat(p,f);
pix=getframe(handles.axes1);
imwrite(pix.cdata,str,'jpg')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)  %clear
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);   %清除axes中所画的图像

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)  %开始识别
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pix=getframe(handles.axes1);
imwrite(pix.cdata,'imgtest.jpg');
newimage = imread('imgtest.jpg');           %保存新画的数字

newimgResult = identify(newimage) ;                  %通过识别函数进行比较
Result = BpRecognize(newimgResult);
msgbox(num2str(Result),'识别结果','help');



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %train
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BpTrain();
msgbox('Finish Train','提示','modal');




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%鼠标按下事件
global ButtonDown pos1;  
if(strcmp(get(gcf,'SelectionType'),'normal'))%判断鼠标按下的类型，normal为左键  
    ButtonDown=1;  
    pos1=get(handles.axes1,'CurrentPoint');%获取坐标轴上鼠标的位置  
end  


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%鼠标运动相应
global ButtonDown pos1;  
if ButtonDown == 1  
    pos = get(handles.axes1, 'CurrentPoint');%获取当前位置  
    line([pos1(1,1) pos(1,1)],[pos1(1,2) pos(1,2)],'LineStyle','-','LineWidth',8,'Color','Black','Marker','.','MarkerSize',20);
    %划线，设置了线的宽度为8，颜色为黑色，转折点用‘.’补充，大小为20  
    pos1 = pos;%更新  
end  


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%鼠标按键抬起的响应事件  
global ButtonDown;  
ButtonDown = 0;  
