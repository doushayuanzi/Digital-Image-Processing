function varargout = example(varargin)
% EXAMPLE MATLAB code for example.fig
%      EXAMPLE, by itself, creates a new EXAMPLE or raises the existing
%      singleton*.
%
%      H = EXAMPLE returns the handle to a new EXAMPLE or the handle to
%      the existing singleton*.
%
%      EXAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXAMPLE.M with the given input arguments.
%
%      EXAMPLE('Property','Value',...) creates a new EXAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before example_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to example_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help example

% Last Modified by GUIDE v2.5 22-Dec-2024 20:47:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @example_OpeningFcn, ...
                   'gui_OutputFcn',  @example_OutputFcn, ...
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


% --- Executes just before example is made visible.
function example_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to example (see VARARGIN)

% Choose default command line output for example
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes example wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = example_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.打开图片
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
[filename,pathname]=uigetfile('*jpg','选择图片');
path=[pathname filename];
I=imread(path);
axes(handles.axes1)
imshow(I)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.双线性缩放
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I  % 获取全局变量I（源图像）

% 检查图像是否为空
if isempty(I)
    msgbox('请先选择源图像。', '错误', 'error');
    return;
end

% 弹出输入框让用户输入缩放因子
prompt = {'请输入缩放因子 (例如：0.5表示缩小，2表示放大):'};
dlgtitle = '输入缩放因子';
dims = [1 35];
definput = {'1.0'};  % 默认值为 1.0 (表示不缩放)
answer = inputdlg(prompt, dlgtitle, dims, definput);

% 判断用户是否点击了“确定”
if ~isempty(answer)
    % 获取用户输入的缩放因子
    scale_factor = str2double(answer{1});
    
    % 检查缩放因子是否为有效的正数
    if scale_factor <= 0
        errordlg('请输入一个正的缩放因子!', '输入错误');
        return;
    end
    
    % 使用双线性插值进行图像缩放
    I_resized = bilinearResize(I, scale_factor);
    
    % 显示缩放后的图像
    axes(handles.axes2); 
    imshow(I_resized);
    
    % 更新 handles 结构，保存缩放后的图像
    handles.I_resized = I_resized;
    guidata(hObject, handles);  % 更新 handles
end

function I_resized = bilinearResize(I, scale_factor)
    % 获取源图像的尺寸
    [rows, cols, channels] = size(I);
    
    % 计算目标图像的尺寸
    new_rows = round(rows * scale_factor);
    new_cols = round(cols * scale_factor);
    
    % 创建一个新的图像用于保存缩放后的图像
    I_resized = zeros(new_rows, new_cols, channels, 'uint8');
    
    % 对目标图像中的每个像素进行插值
    for i = 1:new_rows
        for j = 1:new_cols
            % 计算源图像中对应的浮动位置
            orig_x = (i - 1) / scale_factor + 1;  % 计算源图像的X坐标
            orig_y = (j - 1) / scale_factor + 1;  % 计算源图像的Y坐标
            
            % 获取四个邻近像素的坐标
            x1 = floor(orig_x);
            x2 = min(x1 + 1, rows);  % 防止越界
            y1 = floor(orig_y);
            y2 = min(y1 + 1, cols);  % 防止越界
            
            % 计算水平和垂直方向上的插值
            dx = orig_x - x1;
            dy = orig_y - y1;
            
            for c = 1:channels  % 对每个通道进行插值（如果是彩色图像）
                % 计算插值结果
                top = (1 - dx) * double(I(x1, y1, c)) + dx * double(I(x2, y1, c));
                bottom = (1 - dx) * double(I(x1, y2, c)) + dx * double(I(x2, y2, c));
                I_resized(i, j, c) = uint8((1 - dy) * top + dy * bottom);
            end
        end
    end


% --- Executes on button press in pushbutton18.旋转
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I  % 获取全局变量I（源图像）

% 检查图像是否为空
if isempty(I)
    msgbox('请先选择源图像。', '错误', 'error');
    return;
end

% 弹出输入框让用户输入旋转角度
prompt = {'请输入顺时针旋转的角度 (单位: 度):'};
dlgtitle = '输入旋转角度';
dims = [1 35];
definput = {'0'};  % 默认值为 0 度 (不旋转)
answer = inputdlg(prompt, dlgtitle, dims, definput);

% 判断用户是否点击了“确定”
if ~isempty(answer)
    % 获取用户输入的旋转角度
    angle = str2double(answer{1});
    
    % 检查角度是否有效
    if isnan(angle)
        errordlg('请输入一个有效的数字作为旋转角度!', '输入错误');
        return;
    end
    
    % 使用 imrotate 函数对图像进行旋转，顺时针旋转角度
    I_rotated = rotate_image(I, angle);
    
    % 获取旋转后图像的大小
    [new_rows, new_cols, ~] = size(I_rotated);
    
    % 获取axes的尺寸
    axes_size = get(handles.axes1, 'Position');  % 获取axes的[左, 下, 宽, 高]
    
    % 确保宽度和高度为整数
    axes_width = floor(axes_size(3) * handles.figure1.Position(3));  % axes的宽度
    axes_height = floor(axes_size(4) * handles.figure1.Position(4));  % axes的高度
    
    % 计算旋转后图像相对于axes的位置 (居中显示)
    x_offset = max(0, (axes_width - new_cols) / 2);  % X轴的偏移量
    y_offset = max(0, (axes_height - new_rows) / 2);  % Y轴的偏移量
    
    % 创建一个背景图像，背景颜色为默认背景色（例如，白色）
    background_color = [1, 1, 1];  % 默认背景色 (白色)
    I_background = uint8(ones(axes_height, axes_width, 3) * 255);  % 创建白色背景图
    
    % 将旋转后的图像复制到背景图的中心区域
    I_background(round(y_offset + 1):round(y_offset + new_rows), round(x_offset + 1):round(x_offset + new_cols), :) = I_rotated;
    
    % 显示旋转后的图像（包括背景）
    axes(handles.axes2);  % 设置目标axes为axes1
    imshow(I_rotated, 'InitialMagnification', 'fit');  % 图像自动适应坐标轴大小
    
    % 更新 handles 结构，保存旋转后的图像
    handles.I_rotated = I_rotated;
    guidata(hObject, handles);  % 更新 handles
end

function I_rotated = rotate_image(I, angle)
    % 旋转图像 I，角度为 angle（单位：度）
    % angle 为正表示逆时针旋转，负值表示顺时针旋转
    
    % 将角度转换为弧度
    theta = deg2rad(angle);
    
    % 获取图像的大小
    [rows, cols, channels] = size(I);
    
    % 计算旋转矩阵
    rotation_matrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    
    % 计算旋转后的图像尺寸
    % 通过旋转后最大可能的边界来估算
    corners = [
        1, 1;                  % 左上角
        1, cols;               % 右上角
        rows, 1;               % 左下角
        rows, cols;            % 右下角
    ];
    
    % 计算旋转后四个角的位置
    new_corners = (rotation_matrix * corners')';
    
    % 计算旋转后图像的边界
    min_x = min(new_corners(:, 1));
    max_x = max(new_corners(:, 1));
    min_y = min(new_corners(:, 2));
    max_y = max(new_corners(:, 2));
    
    % 计算旋转后的图像的大小
    new_width = ceil(max_x - min_x);
    new_height = ceil(max_y - min_y);
    
    % 创建一个空白图像作为旋转后的图像
    I_rotated = uint8(zeros(new_height, new_width, channels));
    
    % 计算原图像的中心点
    center_x = (cols + 1) / 2;
    center_y = (rows + 1) / 2;
    
    % 计算旋转后的图像的中心点
    new_center_x = (new_width + 1) / 2;
    new_center_y = (new_height + 1) / 2;
    
    % 对每个目标像素进行反向映射到原图像
    for i = 1:new_height
        for j = 1:new_width
            % 计算目标像素相对于新图像中心的坐标
            new_x = j - new_center_x;
            new_y = i - new_center_y;
            
            % 通过旋转矩阵计算目标像素对应的原图像坐标
            original_coords = rotation_matrix' * [new_x; new_y];
            orig_x = original_coords(1) + center_x;
            orig_y = original_coords(2) + center_y;
            
            % 使用最近邻插值填充像素值
            if orig_x >= 1 && orig_x <= cols && orig_y >= 1 && orig_y <= rows
                I_rotated(i, j, :) = I(round(orig_y), round(orig_x), :);
            end
        end
    end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.椒盐噪声
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
J=add_salt_and_pepper_noise(I,0.02);
axes(handles.axes2)
imshow(J)

function noisy_image = add_salt_and_pepper_noise(image, noise_density)
    % 输入：
    % image：原始图像，应该是一个二维灰度图或RGB图像
    % noise_density：椒盐噪声的密度，值在 [0, 1] 范围，表示噪声的比例
    %
    % 输出：
    % noisy_image：加了椒盐噪声的图像

    % 确保输入的图像为 uint8 类型
    if ~isa(image, 'uint8')
        image = im2uint8(image);
    end
    
    % 获取图像的尺寸
    [rows, cols, channels] = size(image);
    
    % 随机生成椒盐噪声
    num_pixels = round(noise_density * rows * cols);  % 噪声点的数量
    
    % 生成盐噪声 (白色像素)
    salt_indices = rand(num_pixels, 2);
    salt_indices = round(salt_indices .* [rows-1, cols-1]) + 1;  % 转换为像素坐标
    for i = 1:num_pixels
        image(salt_indices(i,1), salt_indices(i,2), :) = 255;  % 设置为白色像素
    end
    
    % 生成椒噪声 (黑色像素)
    pepper_indices = rand(num_pixels, 2);
    pepper_indices = round(pepper_indices .* [rows-1, cols-1]) + 1;  % 转换为像素坐标
    for i = 1:num_pixels
        image(pepper_indices(i,1), pepper_indices(i,2), :) = 0;  % 设置为黑色像素
    end
    
    % 返回加噪声后的图像
    noisy_image = image;

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.线性对比度增强
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I  % 获取全局变量I（源图像）

% 如果源图像是彩色图像，则转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);  % 转换为灰度图像
else
    I_gray = I;  % 已经是灰度图像
end

% 线性对比度增强
I_enhanced = linear_contrast_enhancement(I_gray);

% 显示增强后的图像
axes(handles.axes2);  % 假设显示图像的 axes 是 axes1
imshow(I_enhanced);

% 更新 handles 结构，保存增强后的图像
handles.I_enhanced = I_enhanced;
guidata(hObject, handles);  % 更新 handles

% 线性对比度增强的实现
function enhanced_img = linear_contrast_enhancement(src_img)
    % 获取图像的最小值和最大值
    I_min = double(min(src_img(:)));
    I_max = double(max(src_img(:)));
    
    % 计算线性变换后的图像
    enhanced_img = uint8((double(src_img) - I_min) / (I_max - I_min) * 255);


% --- Executes on button press in pushbutton5.对数变换
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I  % 获取全局变量I（源图像）

% 检查图像是否为空
if isempty(I)
    msgbox('请先选择源图像。', '错误', 'error');
    return;
end

% 如果源图像是彩色图像，则转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);  % 转换为灰度图像
else
    I_gray = I;  % 已经是灰度图像
end

% 弹出输入框让用户输入常数 c
prompt = {'请输入常数 c (建议范围: 0.1 - 10):'};
dlgtitle = '输入对数变换常数';
dims = [1 35];
definput = {'1.0'};  % 默认值为 1.0
answer = inputdlg(prompt, dlgtitle, dims, definput);

% 判断用户是否点击了“确定”
if ~isempty(answer)
    % 获取用户输入的常数 c
    c = str2double(answer{1});
    
    % 检查常数 c 是否在合理范围内
    if c < 0.1 || c > 10
        errordlg('请输入一个在 0.1 到 10 范围内的常数 c!', '输入错误');
        return;
    end
    
    % 对数变换操作
    I_transformed = log_transformation(I_gray, c);

    % 显示变换后的图像
    axes(handles.axes2);
    imshow(I_transformed);
    
    % 更新 handles 结构，保存变换后的图像
    handles.I_transformed = I_transformed;
    guidata(hObject, handles);  % 更新 handles
end


% 对数变换的实现
function transformed_img = log_transformation(src_img, c)
    % 对图像进行对数变换
    transformed_img = uint8(c * log(1 + double(src_img)));
    
    % 将变换后的像素值限制在 0 到 255 之间
    transformed_img = min(max(transformed_img, 0), 255);


% --- Executes on button press in pushbutton19.指数变换
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global I  % 获取全局变量I（源图像）

% 检查图像是否为空
if isempty(I)
    msgbox('请先选择源图像。', '错误', 'error');
    return;
end

% 如果源图像是彩色图像，则转换为灰度图
if size(I, 3) == 3
    I_gray = rgb2gray(I);  % 转换为灰度图像
else
    I_gray = I;  % 已经是灰度图像
end

% 弹出输入框让用户输入常数 c
prompt = {'请输入常数 c (建议范围: 1 - 10):'};
dlgtitle = '输入指数变换常数';
dims = [1 35];
definput = {'1.0'};  % 默认值为 1.0
answer = inputdlg(prompt, dlgtitle, dims, definput);

% 判断用户是否点击了“确定”
if ~isempty(answer)
    % 获取用户输入的常数 c
    c = str2double(answer{1});
    
    % 检查常数 c 是否在合理范围内
    if c < 1 || c > 10
        errordlg('请输入一个在 1 到 10 范围内的常数 c!', '输入错误');
        return;
    end
    
    % 指数变换操作
    I_transformed = exp_transformation(I_gray, c);

    % 显示变换后的图像
    axes(handles.axes2);  % 假设显示图像的 axes 是 axes1
    imshow(I_transformed);
    
    % 更新 handles 结构，保存变换后的图像
    handles.I_transformed = I_transformed;
    guidata(hObject, handles);  % 更新 handles
end

% 指数变换的实现
function transformed_img = exp_transformation(src_img, c)
    % 对图像进行指数变换
    transformed_img = uint8(c * (exp(double(src_img) / 255) - 1) * 255);
    
    % 将变换后的像素值限制在 0 到 255 之间
    transformed_img = min(max(transformed_img, 0), 255);


% --- Executes on button press in pushbutton3.显示灰度直方图
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
% 如果是彩色图像，调用 my_rgb2gray 转为灰度图像
if size(I, 3) == 3
    grayImage = my_rgb2gray(I);  % 使用我们自定义的 my_rgb2gray 函数
else
    grayImage = I;  % 如果已经是灰度图像，则无需转换
end

% 获取图像的大小
[rows, cols] = size(grayImage);

% 计算灰度直方图
% 初始化一个 256 元素的数组来存储每个灰度级别的像素数量
histData = zeros(1, 256);

% 遍历每个像素，统计每个灰度值的出现次数
for i = 1:rows
    for j = 1:cols
        grayValue = grayImage(i, j);
        histData(grayValue + 1) = histData(grayValue + 1) + 1;  % 加 1 是因为灰度值从 0 到 255
    end
end

% 绘制直方图
axes(handles.axes2);  % 显示在指定的 axes 上
bar(0:255, histData, 'BarWidth', 0.2);
title('灰度直方图');
xlabel('灰度值');
ylabel('像素数');


% --- Executes on button press in pushbutton4.直方图均衡化
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 这个函数会在 pushbutton4 被点击时触发
% 获取当前图像
global I  % 获取全局变量I（原图像）

% 检查图像是否为空
if isempty(I)
    msgbox('请先选择一张图像。', '错误', 'error');
    return;
end

% 如果图像是彩色图像，则转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);  % 转换为灰度图像
else
    I_gray = I;  % 已经是灰度图像
end

% 直方图均衡化
I_eq = hist_equalization(I_gray);

% 显示均衡化后的图像
axes(handles.axes2); 
imshow(I_eq);

% 更新 handles 结构，保存均衡化后的图像
handles.I_eq = I_eq;
guidata(hObject, handles);  % 更新 handles

% 直方图均衡化的实现
function eq_img = hist_equalization(img)
    % 获取图像的尺寸
    [rows, cols] = size(img);

    % 计算图像的灰度直方图
    histData = zeros(1, 256);  % 256个灰度级的直方图
    for i = 1:rows
        for j = 1:cols
            pixelValue = img(i, j);
            histData(pixelValue + 1) = histData(pixelValue + 1) + 1;  % 累加每个灰度值的频率
        end
    end

    % 计算累积分布函数（CDF）
    cdf = cumsum(histData);  % 累积直方图
    cdf = cdf / (rows * cols);  % 归一化CDF

    % 计算映射函数
    cdf_min = min(cdf(cdf > 0));  % 找到CDF中的最小非零值
    cdf_range = cdf(end) - cdf_min;  % 计算CDF的范围

    % 使用CDF进行灰度级映射
    eq_img = uint8(255 * (cdf(double(img) + 1) - cdf_min) / cdf_range);  % 进行灰度级映射



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.高斯噪声
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
% 假设 I 已经是一个有效的图像
mean = 0;  % 高斯噪声均值
std_dev = 25;  % 高斯噪声标准差（可以调整强度）
J = add_gaussian_noise(I, mean, std_dev);  % 添加高斯噪声
axes(handles.axes2);  % 将图像显示到 axes2
imshow(J);  % 显示添加噪声后的图像

function noisy_image = add_gaussian_noise(image, mean, std_dev)
    if ~isa(image, 'uint8')
        image = im2uint8(image);
    end
    
    % 获取图像的尺寸
    [rows, cols, channels] = size(image);
    
    % 生成与图像相同大小的高斯噪声
    noise = mean + std_dev * randn(rows, cols, channels);
    
    % 将噪声加到图像上，注意保持数据类型不变
    noisy_image = double(image) + noise;  % 转换为 double 型以处理加法

    % 确保噪声加后的图像值在 [0, 255] 范围内，并转换回 uint8
    noisy_image = uint8(min(max(noisy_image, 0), 255));

% --- Executes on button press in pushbutton22.直方图匹配
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I_target  % 获取全局变量I（源图像）和I_target（目标图像）
[filename,pathname]=uigetfile('*jpg','选择目标图片');
path1=[pathname filename];
I_target=imread(path1);
% 检查图像是否为空
if isempty(I) || isempty(I_target)
    msgbox('请先目标图像。', '错误', 'error');
    return;
end

% 如果源图像是彩色图像，则转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);  % 转换为灰度图像
else
    I_gray = I;  % 已经是灰度图像
end

% 如果目标图像是彩色图像，则转换为灰度图
if size(I_target, 3) == 3
    I_target_gray = rgb2gray(I_target);  % 转换为灰度图像
else
    I_target_gray = I_target;  % 已经是灰度图像
end

% 直方图匹配
I_matched = hist_matching(I_gray, I_target_gray);

% 显示匹配后的图像
axes(handles.axes2);  % 假设显示图像的 axes 是 axes1
imshow(I_matched);

% 更新 handles 结构，保存匹配后的图像
handles.I_matched = I_matched;
guidata(hObject, handles);  % 更新 handles

% 直方图匹配的实现
function matched_img = hist_matching(src_img, target_img)
    % 获取图像的尺寸
    [rows, cols] = size(src_img);

    % 计算源图像和目标图像的灰度直方图
    src_hist = histcounts(src_img(:), 0:256);
    target_hist = histcounts(target_img(:), 0:256);

    % 计算源图像和目标图像的累积分布函数（CDF）
    src_cdf = cumsum(src_hist) / sum(src_hist);
    target_cdf = cumsum(target_hist) / sum(target_hist);

    % 找到源图像的每个灰度值对应的目标图像灰度值
    % 使用最小绝对差法来找到匹配的灰度级
    [~, src_map] = min(abs(src_cdf' - target_cdf), [], 2);
    
    % 映射源图像到目标图像
    matched_img = uint8(src_map(double(src_img) + 1) - 1);  % 使用映射得到匹配后的图像

%灰度化
function grayImage = my_rgb2gray(rgbImage)

    % 输入：rgbImage - 彩色图像（MxNx3）
    % 输出：grayImage - 灰度图像（MxN）

    % 获取图像的各个通道
    R = rgbImage(:,:,1);  % 红色通道
    G = rgbImage(:,:,2);  % 绿色通道
    B = rgbImage(:,:,3);  % 蓝色通道

    % 使用加权平均法转换为灰度图像
    grayImage = 0.2989 * R + 0.5870 * G + 0.1140 * B;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
