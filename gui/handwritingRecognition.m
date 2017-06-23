function varargout = handwritingRecognition(varargin)
% HANDWRITINGRECOGNITION MATLAB code for handwritingRecognition.fig
%      HANDWRITINGRECOGNITION, by itself, creates a new HANDWRITINGRECOGNITION or raises the existing
%      singleton*.
%
%      H = HANDWRITINGRECOGNITION returns the handle to a new HANDWRITINGRECOGNITION or the handle to
%      the existing singleton*.
%
%      HANDWRITINGRECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HANDWRITINGRECOGNITION.M with the given input arguments.
%
%      HANDWRITINGRECOGNITION('Property','Value',...) creates a new HANDWRITINGRECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before handwritingRecognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to handwritingRecognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help handwritingRecognition

% Last Modified by GUIDE v2.5 19-Jun-2017 23:48:31

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
  'gui_Singleton', gui_Singleton, ...
  'gui_OpeningFcn', @handwritingRecognition_OpeningFcn, ...
  'gui_OutputFcn', @handwritingRecognition_OutputFcn, ...
  'gui_LayoutFcn', [], ...
  'gui_Callback', []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before handwritingRecognition is made visible.
function handwritingRecognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to handwritingRecognition (see VARARGIN)

% Choose default command line output for handwritingRecognition
handles.output = hObject;
config = setup();
handles.config = config;

axes(handles.axesNumerals); imshow(imresize(imread(config.NUMERALS_IMG), [100, 200]));
axes(handles.axesVowels); imshow(imresize(imread(config.VOWELS_IMG), [100, 200]));
axes(handles.axesConsonants); imshow(imresize(imread(config.CONSONANTS_IMG), [120, 200]));

mlpNumModel = load(config.NUMERALS_MODEL_MLP);
models.mlpNumModel = mlpNumModel.model;
rbfNumModel = load(config.NUMERALS_MODEL_RBF);
models.rbfNumModel = rbfNumModel.model;
models.numLabels = mlpNumModel.model.labels;

mlpVowModel = load(config.VOWELS_MODEL_MLP);
models.mlpVowModel = mlpVowModel.model;
rbfVowModel = load(config.VOWELS_MODEL_RBF);
models.rbfVowModel = rbfVowModel.model;
models.vowLabels = mlpVowModel.model.labels;

mlpConModel = load(config.CONSONANTS_MODEL_MLP);
models.mlpConModel = mlpConModel.model;
rbfConModel = load(config.CONSONANTS_MODEL_RBF);
models.rbfConModel = rbfConModel.model;
models.conLabels = mlpConModel.model.labels;

samples = load(config.SAMPLES_MAT_FILE); %readClassSamples(config);

handles.models = models;
handles.samples = samples.samples;

handles.fileLoaded1 = 0;
handles.fileLoaded2 = 0;
handles.fileLoaded3 = 0;
handles.fileLoaded4 = 0;
handles.vidLoaded = 0;

handles.image2 = getimage(handles.axes2);
handles.image3 = getimage(handles.axes3);
handles.vid = '';

set(handles.axes1, 'Visible', 'off');
set(handles.axes2, 'Visible', 'off');
set(handles.axes3, 'Visible', 'off');
set(handles.axesMLP, 'Visible', 'off');
set(handles.axesRBF, 'Visible', 'off');

set(handles.axes1, 'XTick', []);
set(handles.axes1, 'YTick', []);

set(handles.axes2, 'XTick', []);
set(handles.axes2, 'YTick', []);

set(handles.axes3, 'XTick', []);
set(handles.axes3, 'YTick', []);

set(handles.axesMLP, 'XTick', []);
set(handles.axesMLP, 'YTick', []);

set(handles.axesRBF, 'XTick', []);
set(handles.axesRBF, 'YTick', []);

handles.denoiseFlag = 0;
handles.inversionFlag = 0;
handles.dilateFlag = 0;
handles.discourseFlag = 0;
handles.sizeNormalizationFlag = 0;
handles.skeletonFlag = 0;

set(handles.sliderRotate, 'Enable', 'off');
set(handles.sliderContrast, 'Enable', 'off');
set(handles.sliderBrightness, 'Enable', 'off');
set(handles.pushbuttonResize, 'Enable', 'off');
set(handles.btn_crop_image, 'Enable', 'off');
set(handles.pushbuttonSaveImage2, 'Enable', 'off');
set(handles.pushbuttonClear, 'Enable', 'off');
set(handles.btnApply, 'Enable', 'off');

set(handles.pushbuttonGrayScaleConversion, 'Enable', 'off');
set(handles.pushbuttonNoiseRemoval, 'Enable', 'off');
set(handles.pushbuttonImageBinarization, 'Enable', 'off');
set(handles.pushbuttonImageInversion, 'Enable', 'off');
set(handles.pushbuttonUniverseOfDiscourse, 'Enable', 'off');
set(handles.pushbuttonSizeNormalization, 'Enable', 'off');
set(handles.pushbuttonImageSkeletonization, 'Enable', 'off');
set(handles.pushbuttonClear2, 'Enable', 'off');
set(handles.pushbuttonSaveImage3, 'Enable', 'off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes handwritingRecognition wait for user response (see UIRESUME)
% uiwait(handles.figureMain);

% --- Outputs from this function are returned to the command line.
function varargout = handwritingRecognition_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnLoadImage.
function btnLoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uigetfile({'*.*'}, 'Load Image File');

if (FileName == 0) % cancel pressed
    return;
end

handles.fullPath = [PathName FileName];
[~, ~, Ext] = fileparts(FileName);
availableExt = {'.bmp', '.jpg', '.jpeg', '.tiff', '.png', '.gif'};
found = 0;
for i = 1:length(availableExt)
    if (strcmpi(Ext, availableExt{i}))
        found = 1;
        break;
    end
end

if (found == 0)
    handles.fileLoaded1 = 0;
    msgbox('File type not supported!', 'Error', 'error');
    return;
end

info = imfinfo(handles.fullPath);
if (~ isempty(info.Comment))
    % save current image comment (to be used later in image save)
    handles.currentImageComment = info.Comment{1};
else
    handles.currentImageComment = '';
end

image1 = imread(handles.fullPath);
handles.image1 = image1;

handles.fileLoaded1 = 1;

set(handles.axes1, 'Visible', 'off');
axes(handles.axes1); cla; imshow(image1);
guidata(hObject, handles);

% % --- Executes on button press in btn_load_image_from_workspace.
% function btn_load_image_from_workspace_Callback(hObject, eventdata, handles)
% % hObject    handle to btn_load_image_from_workspace (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% prompt = {'Enter image variable name:'};
% title = 'Load image from workspace';
% answer = inputdlg(prompt, title);
%
% if isempty(answer) % cancel pressed
%     return;
% end
% varName=answer{1};
% try
% image1 = evalin('base',varName);
% handles.image1 = image1;
%
% handles.fileLoaded1 = 1;
%
% set(handles.axes1,'Visible','off');
% axes(handles.axes1); cla; imshow(image1);
% guidata(hObject, handles);
% catch exception
%    msgbox('Variable not found in matlab workspace');
% end

% --- Executes on button press in btnWebcam.
function btnWebcam_Callback(hObject, eventdata, handles)
% hObject    handle to btnWebcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IA DeviceID
IA = 'winvideo'; DeviceID = 1;
try
    vid = videoinput(IA, DeviceID);
    set(vid, 'ReturnedColorSpace', 'RGB');
    handles.vid = vid;
    handles.vid.FramesPerTrigger = 1;
    % output would image in RGB color space
    handles.vid.ReturnedColorspace = 'rgb';
    % tell matlab to start the webcam on user request, not automatically
    triggerconfig(handles.vid, 'manual');
    % we need this to know the image height and width
    vidRes = get(handles.vid, 'VideoResolution');
    % image width
    imWidth = vidRes(1);
    % image height
    imHeight = vidRes(2);
    % number of bands of our image (should be 3 because it's RGB)
    nBands = get(handles.vid, 'NumberOfBands');
    % create an empty image container and show it on axPreview
    hImage = image(zeros(imHeight, imWidth, nBands), 'parent', handles.axes1);
    preview(handles.vid, hImage)
    handles.vidLoaded = 1;
catch E
    msgbox({'Configure The Camera Correctly!', ' ', E.message}, 'CAM INFO')
end
guidata(hObject, handles);

% --- Executes on button press in btnCapture.
function btnCapture_Callback(hObject, eventdata, handles)
% hObject    handle to btnCapture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.vidLoaded == 1)
 
    handles.vidLoaded = 0;
    image1 = getsnapshot(handles.vid);
    closepreview
 
    set(handles.axes1, 'Visible', 'off');
    imshow(image1, 'parent', handles.axes1);
    handles.fileLoaded1 = 1;
    handles.image1 = image1;
else
    msgbox('Plz! start webcam first')
end

guidata(hObject, handles);

% --- Executes on button press in btnDraw.
function btnDraw_Callback(hObject, eventdata, handles)
% hObject    handle to btnDraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'Visible', 'on');
axes(handles.axes1); cla;
axis tight;
set(gca, 'xtick', [], 'ytick', []);
userDraw(handles);
pause;
% [myobj,xs,ys] = freehanddraw(handles.axes1,'color','b','linewidth',3);
image1 = getframe(handles.axes1);
image1 = image1.cdata;
axes(handles.axes1); imshow(image1);
image1 = getimage(handles.axes1);
set(handles.axes1, 'Visible', 'off');
axes(handles.axes1); imshow(image1);
handles.image1 = image1;
handles.fileLoaded1 = 1;

guidata(hObject, handles);

% --- Executes on button press in btnSave1.
function btnSave1_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded1 == 1)
    [file, path] = uiputfile('*.jpg', 'Save Secondary Image As');
    if (file == 0)
        return;
    end
    image1 = getimage(handles.axes1);
    imwrite(image1, [path file], 'jpg');
else
    msgbox('No file has been loaded!', 'Save Error', 'error');
end

% --- Executes on button press in btn_crop_image.
function btn_crop_image_Callback(hObject, eventdata, handles)
% hObject    handle to btn_crop_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.image2 = imcrop(handles.axes2);
axes(handles.axes2); imshow(handles.image2);
guidata(hObject, handles);

% --- Executes on button press in sliderRotate.
function sliderRotate_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sliderMin = 0;
sliderMax = 180;
sliderStep = [0.2 0.2];
set(handles.sliderRotate, 'Min', sliderMin);
set(handles.sliderRotate, 'Max', sliderMax);
set(handles.sliderRotate, 'SliderStep', sliderStep);
slider_value = get(handles.sliderRotate, 'Value');
set(handles.textRotate, 'String', sprintf('%s (%4.0f %s)', 'Rotate Image', slider_value, 'degree'));
%image2=getimage(handles.axes2);
image2 = handles.image2;
image = imrotate(image2, round(slider_value), 'bicubic');
axes(handles.axes2); imshow(image);
guidata(hObject, handles);

%
% % --- Executes on slider movement.
% function sliderZoom_Callback(hObject, eventdata, handles)
% % hObject    handle to sliderZoom (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: get(hObject,'Value') returns position of slider
% %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% sliderMin=0;
% sliderMax=100;
% sliderStep=[0.01 0.10];
% set(handles.sliderZoom,'Min',sliderMin);
% set(handles.sliderZoom,'Max',sliderMax);
% set(handles.sliderZoom,'SliderStep',sliderStep);
% slider_value = get(handles.sliderZoom,'Value');
% % image2=getimage(handles.axes2);
% image2=handles.image2;
% axes(handles.axes2);imshow(image2);
% zoom out;
% zoom(round(slider_value));
% txtInfo = sprintf('Zoom Factor = %.2f\n\nOnce zoomed, you can pan by clicking and dragging in the image.', round(slider_value));
% set(handles.sliderZoom, 'TooltipString', txtInfo);
% txtZoom = sprintf('Zoom Factor = (%d )', round(slider_value));
% set(handles.textZoom, 'String', txtZoom);
% % if zoomFactor ~= 1
% % else
% % end
% % Set up to allow panning of the image by clicking and dragging.
% % Cursor will show up as a little hand when it is over the image.
% set(handles.axes2, 'ButtonDownFcn', 'disp(''This executes'')');
% set(handles.axes2, 'Tag', 'DoNotIgnore');
% h = pan;
% set(h, 'ButtonDownFilter', @myPanCallbackFunction);
% set(h, 'Enable', 'on');
% axes(handles.axes2);imshow(image2);
% guidata(hObject, handles);
%
% --- Executes on button press in pushbuttonExit.
function pushbuttonExit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figureMain);

% --- Executes on button press in pushbuttonResize.
function pushbuttonResize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonResize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image2 = handles.image2;
height = str2num(get(handles.editHeight, 'String'));
width = str2num(get(handles.editWidth, 'String'));
image2 = imresize(image2, [height, width]);
% handles.image2=imresize(handles.image2,[height,width]);
axes(handles.axes2); imshow(image2);
guidata(hObject, handles);

% --- Executes on slider movement.
function sliderContrast_Callback(hObject, eventdata, handles)
% hObject    handle to sliderContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.sliderContrast, 'Min', - 1);
set(handles.sliderContrast, 'Max', 1);
set(handles.sliderContrast, 'SliderStep', [0.01, 0.10]);
slider_value = get(handles.sliderContrast, 'Value');
set(handles.textContrast, 'String', sprintf('%s (%4.0f)', 'Contrast', round(slider_value * 100)));
image2 = handles.image2;
image = (image2 - 0.5) * (tan ((slider_value + 1) * pi / 4)) + 0.5;
axes(handles.axes2); imshow(image);
%handles.image2=getimage(handles.axes2);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function sliderContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end

% --- Executes on slider movement.
function sliderBrightness_Callback(hObject, eventdata, handles)
% hObject    handle to sliderBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.sliderBrightness, 'Min', - 1);
set(handles.sliderBrightness, 'Max', 1);
set(handles.sliderBrightness, 'SliderStep', [0.01, 0.1]);
slider_value = get(handles.sliderBrightness, 'Value');
set(handles.textBrightness, 'String', sprintf('%s (%4.0f)', 'Brightness', round(slider_value * 100)));
image2 = handles.image2;
if (slider_value < 0.0)
    image = image2 * (1.0 + slider_value);
else
    image = image2 + ((1.0 - image2) * slider_value);
end
axes(handles.axes2); imshow(image);
%handles.image2=getimage(handles.axes2);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderBrightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end

% --- Executes on button press in pushbuttonSaveImage2.
function pushbuttonSaveImage2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveImage2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded2 == 1)
    [file, path] = uiputfile('*.jpg', 'Save Secondary Image As');
    if (file == 0)
        return;
    end
    image2 = getimage(handles.axes2);
    imwrite(image2, [path file], 'jpg');
else
    h = msgbox('No file has been loaded!', 'Save Error', 'error');
end

% --- Executes on button press in pushbuttonCopy.
function pushbuttonCopy_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded1 == 1)
    handles.image2 = handles.image1;
    axes(handles.axes2); imshow(handles.image2);
    handles.fileLoaded2 = 1;
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!', 'Error', 'error');
    handles.fileLoaded2 = 0;
    return;
end
set(handles.sliderRotate, 'Enable', 'on');
set(handles.sliderContrast, 'Enable', 'on');
set(handles.sliderBrightness, 'Enable', 'on');
set(handles.pushbuttonResize, 'Enable', 'on');
set(handles.btn_crop_image, 'Enable', 'on');
set(handles.pushbuttonSaveImage2, 'Enable', 'on');
set(handles.pushbuttonClear, 'Enable', 'on');
set(handles.btnApply, 'Enable', 'on');

set(handles.sliderRotate, 'Value', 0);
set(handles.sliderContrast, 'Value', 0);
set(handles.sliderBrightness, 'Value', 0);

% [r,c]=size(handles.image2)
% set(handles.editHeight,'String',r);
% set(handles.editWidth,'String',c);
% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded2 == 1)
    axes(handles.axes2); cla
    handles.fileLoaded2 = 0;
    guidata(hObject, handles);
 
    set(handles.sliderRotate, 'Enable', 'off');
 
    set(handles.sliderContrast, 'Enable', 'off');
    set(handles.sliderBrightness, 'Enable', 'off');
    set(handles.pushbuttonResize, 'Enable', 'off');
    set(handles.btn_crop_image, 'Enable', 'off');
    set(handles.pushbuttonSaveImage2, 'Enable', 'off');
    set(handles.pushbuttonClear, 'Enable', 'off');
    set(handles.btnApply, 'Enable', 'off');
 
    set(handles.sliderRotate, 'Value', 0);
    set(handles.sliderContrast, 'Value', 0);
    set(handles.sliderBrightness, 'Value', 0);
 
    set(handles.editWidth, 'String', '36');
    set(handles.editHeight, 'String', '36');
end

% --- Executes on button press in pushbuttonCopy2.
function pushbuttonCopy2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCopy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded2 == 1)
    image3 = getimage(handles.axes2);
    handles.image3 = image3;
    axes(handles.axes3); imshow(handles.image3);
    handles.fileLoaded3 = 1;
    guidata(hObject, handles);
elseif (handles.fileLoaded1 == 1)
    handles.image3 = handles.image1;
    axes(handles.axes3); imshow(handles.image3);
    handles.fileLoaded3 = 1;
    guidata(hObject, handles);
else
    h = msgbox('No primary file has been loaded!', 'Error', 'error');
    handles.fileLoaded3 = 0;
    return;
end
set(handles.pushbuttonGrayScaleConversion, 'Enable', 'on');
set(handles.pushbuttonNoiseRemoval, 'Enable', 'on');
set(handles.pushbuttonImageBinarization, 'Enable', 'on');
set(handles.pushbuttonImageInversion, 'Enable', 'on');
set(handles.pushbuttonUniverseOfDiscourse, 'Enable', 'on');
set(handles.pushbuttonSizeNormalization, 'Enable', 'on');
set(handles.pushbuttonImageSkeletonization, 'Enable', 'on');
set(handles.pushbuttonClear2, 'Enable', 'on');
set(handles.pushbuttonSaveImage3, 'Enable', 'on');

% --- Executes on button press in pushbuttonSaveImage3.
function pushbuttonSaveImage3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveImage3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded3 == 1)
    [file, path] = uiputfile('*.jpg', 'Save Secondary Image As');
    if (file == 0)
        return;
    end
    image3 = getimage(handles.axes3);
    imwrite(image3, [path file], 'jpg');
else
    h = msgbox('No file has been loaded!', 'Save Error', 'error');
end

% --- Executes on button press in pushbuttonClear2.
function pushbuttonClear2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded3 == 1)
    axes(handles.axes3); cla
    handles.fileLoaded3 = 0;
    guidata(hObject, handles);
 
    set(handles.pushbuttonGrayScaleConversion, 'Enable', 'off');
    set(handles.pushbuttonNoiseRemoval, 'Enable', 'off');
    set(handles.pushbuttonImageBinarization, 'Enable', 'off');
    set(handles.pushbuttonImageInversion, 'Enable', 'off');
    set(handles.pushbuttonUniverseOfDiscourse, 'Enable', 'off');
    set(handles.pushbuttonSizeNormalization, 'Enable', 'off');
    set(handles.pushbuttonImageSkeletonization, 'Enable', 'off');
    set(handles.pushbuttonClear2, 'Enable', 'off');
    set(handles.pushbuttonSaveImage3, 'Enable', 'off');
end
% --- Executes on button press in pushbuttongrayscaleconversion.
function pushbuttonGrayScaleConversion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttongrayscaleconversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
    axes(handles.axes3); imshow(image3);
end
guidata(hObject, handles);

% --- Executes on button press in pushbuttonnoiseremoval.
function pushbuttonNoiseRemoval_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonnoiseremoval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
end
image3 = medfilt2(image3);
image3 = image3(2:end - 1, 2:end - 1); % remove corner pixels
handles.denoiseFlag = 1;
axes(handles.axes3); imshow(image3);
guidata(hObject, handles);

% --- Executes on button press in pushbuttonImageBinarization.
function pushbuttonImageBinarization_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImageBinarization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
end
image3 = im2bw(image3);
axes(handles.axes3); imshow(image3);
guidata(hObject, handles);

% --- Executes on button press in pushbuttonImageInversion.
function pushbuttonImageInversion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImageInversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
end
if ~ islogical(image3)
    image3 = im2bw(image3);
end
image3 = ~ image3;
handles.inversionFlag = 1;

image3 = imdilate(image3, strel('square', 2));
handles.dilateFlag = 1;

axes(handles.axes3); imshow(image3);
guidata(hObject, handles);

% --- Executes on button press in pushbuttonUniverseOfDiscourse.
function pushbuttonUniverseOfDiscourse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUniverseOfDiscourse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
end
if ~ islogical(image3)
    image3 = im2bw(image3);
end
image3 = image3(3:end - 2, 3:end - 2);
image3 = universe_of_discourse(image3);
handles.discourseFlag = 1;
axes(handles.axes3); imshow(image3);
guidata(hObject, handles);

% --- Executes on button press in pushbuttonSizeNormalization.
function pushbuttonSizeNormalization_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSizeNormalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
end
image3 = imresize(image3, [36, 36], 'bicubic');

handles.sizeNormalizationFlag = 1;

axes(handles.axes3); imshow(image3);
guidata(hObject, handles);

% --- Executes on button press in pushbuttonImageSkeletonization.
function pushbuttonImageSkeletonization_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImageSkeletonization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image3 = getimage(handles.axes3);
if numel(size(image3)) == 3
    image3 = rgb2gray(image3);
end
if ~ islogical(image3)
    image3 = im2bw(image3);
end
image3 = bwmorph(image3, 'skel', 'inf');
axes(handles.axes3); imshow(image3);
handles.skeletonFlag = 1;
guidata(hObject, handles);

% --- Executes on button press in pushbuttonRecognize.
function pushbuttonRecognize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRecognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = getimage(handles.axes3);
image1 = handles.image3;
%--------------------------------
%Preprocess the image
if numel(size(image)) == 3
    image = rgb2gray(image);
end

if (handles.denoiseFlag ~= 1)
    image = medfilt2(image, [3, 3]);
    image = image(2:end - 1, 2:end - 1);
end

if ~ islogical(image)
    image = im2bw(image);
end

if (handles.inversionFlag ~= 1)
    image = ~ image;
end
image = image(3:end - 2, 3:end - 2);

if (handles.discourseFlag ~= 1)
    image = universe_of_discourse(image);
end
if (handles.dilateFlag ~= 1)
    image = imdilate(image, strel('square', 2));
end
if (handles.sizeNormalizationFlag ~= 1)
    image = imresize(image, [36, 36], 'bicubic');
end

if (handles.skeletonFlag ~= 1)
    image = bwmorph(image, 'skel', 'inf');
end

%--------------------------------
%Preprocess the original Image
image1 = preprocessingImage(image1);
features = extractFeaturesFromImage(image1);

if (get(handles.radiobuttonNumeral, 'Value') == 1)
    output1 = sim(handles.models.mlpNumModel.net, features');
    [value1, index1] = max(output1);
 
    output2 = sim(handles.models.rbfNumModel.net, features');
    [value2, index2] = max(output2);
 
    text1 = strcat(num2str(value1));
    text2 = strcat(num2str(value2));
 
    axes(handles.axesMLP);
    handles.fileLoadedMLP = 1;
    imshow(handles.samples.numeralsOptical(index1 - 1)); text(1, 40, text1, 'FontSize', 14); title('MLP');
 
    axes(handles.axesRBF);
    handles.fileLoadedRBF = 1;
    imshow(handles.samples.numeralsOptical(index2 - 1)); text(1, 40, text2, 'FontSize', 14); title('RBF')
elseif (get(handles.radiobuttonVowel, 'Value') == 1)
    output1 = sim(handles.models.mlpVowModel.net, features');
    [value1, index1] = max(output1);
 
    output2 = sim(handles.models.rbfVowModel.net, features');
    [value2, index2] = max(output2);
 
    text1 = strcat(num2str(value1));
    text2 = strcat(num2str(value2));
 
    axes(handles.axesMLP);
    handles.fileLoadedMLP = 1;
    imshow(handles.samples.vowelsOptical(index1)); text(1, 40, text1, 'FontSize', 14); title('MLP');
 
    axes(handles.axesRBF);
    handles.fileLoadedRBF = 1;
    imshow(handles.samples.vowelsOptical(index2)); text(1, 40, text2, 'FontSize', 14); title('RBF')
elseif (get(handles.radiobuttonConsonant, 'Value') == 1)
    output1 = sim(handles.models.mlpConModel.net, features');
    [value1, index1] = max(output1);
 
    output2 = sim(handles.models.rbfConModel.net, features');
    [value2, index2] = max(output2);
 
    text1 = strcat(num2str(value1));
    text2 = strcat(num2str(value2));
 
    axes(handles.axesMLP);
    handles.fileLoadedMLP = 1;
    imshow(handles.samples.consonantsOptical(index1)); text(1, 40, text1, 'FontSize', 14); title('MLP');
 
    axes(handles.axesRBF);
    handles.fileLoadedRBF = 1;
    imshow(handles.samples.consonantsOptical(index2)); text(1, 40, text2, 'FontSize', 14); title('RBF')
 
end
guidata(hObject, handles);

% --- Executes on button press in pushbuttonClear3.
function pushbuttonClear3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoadedMLP == 1)
    axes(handles.axesMLP); cla; title('')
    handles.fileLoadedMLP = 0;
end
if (handles.fileLoadedRBF == 1)
    axes(handles.axesRBF); cla; title('')
    handles.fileLoadedRBF = 0;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderRotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', [.9 .9 .9]);
end

% % --- Executes during object creation, after setting all properties.
% function sliderZoom_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to sliderZoom (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end

% --- Executes during object creation, after setting all properties.
function editHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end

% --- Executes during object creation, after setting all properties.
function editWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end

% --- Executes on button press in btnApply.
function btnApply_Callback(hObject, eventdata, handles)
% hObject    handle to btnApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.image2 = getimage(handles.axes2);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function btnLoadImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btnLoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
