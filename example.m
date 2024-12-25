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

%打开图片
% --- Executes on button press in pushbutton1.
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

% 直方图均衡化函数
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
    I_target_gray = my_rgb2gray(I_target);  % 转换为灰度图像
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

% 直方图匹配函数
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

% 线性对比度增强函数
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
    
    % 创建一个背景图像，背景颜色为默认背景色
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
%旋转函数
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






% --- Executes on button press in pushbutton7.椒盐噪声
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I J
J=add_salt_and_pepper_noise(I,0.02);
axes(handles.axes2)
imshow(J)

function noisy_image = add_salt_and_pepper_noise(image, noise_density)
    % image：原始图像，应该是一个二维灰度图或RGB图像
    % noise_density：椒盐噪声的密度，值在 [0, 1] 范围，表示噪声的比例

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

% --- Executes on button press in pushbutton23.高斯噪声
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I J
mean = 0;  % 高斯噪声均值
std_dev = 25;  % 高斯噪声标准差
J = add_gaussian_noise(I, mean, std_dev);  % 添加高斯噪声
axes(handles.axes2);  % 将图像显示到 axes2
imshow(J);  % 显示添加噪声后的图像

%加高斯噪声
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

% --- Executes on button press in pushbutton8.空域滤波
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global J

% 确保图片已加载
if isempty(J)
    msgbox('请先加载图片！', '错误', 'error');
    return;
end

% 弹出选择框，选择滤波类型
choice = menu('请选择滤波类型', '均值滤波', '中值滤波', '高斯滤波');


% 根据选择进行相应的操作
switch choice
    case 1 % 均值滤波
        % 调用自定义的均值滤波函数
        J_filtered = mean_filter(J, 3); %使用 3x3 的滤波器
        imshow(J_filtered, 'Parent', handles.axes2); % 在 axes1 中显示滤波后的图像
        title('均值滤波');
        
    case 2 % 中值滤波
        % 调用自定义的中值滤波函数
        J_filtered = median_filter(J, 3); % 使用 3x3 的滤波器
        imshow(J_filtered, 'Parent', handles.axes2); % 在 axes1 中显示滤波后的图像
        title('中值滤波');
        
    case 3 % 高斯滤波
        % 调用自定义的高斯滤波函数
        J_filtered = gaussian_filter(J, 3, 0.5); % 3x3 的高斯滤波器，sigma=0.5
        imshow(J_filtered, 'Parent', handles.axes2);
        title('高斯滤波');
        
    otherwise
        % 如果用户点击了取消
        msgbox('未选择滤波方式', '信息', 'help');
end

%均值滤波
function I_filtered = mean_filter(image, window_size)
    % 获取图像的尺寸
    [m, n, c] = size(image);
    
    % 创建一个空的输出图像
    I_filtered = zeros(m, n, c, 'like', image); % 使用'like'来保持数据类型
    
    % 计算邻域的一半大小（注意要取整）
    half_window = floor(window_size / 2);
    
    % 遍历图像的每个像素
    for i = 1:m
        for j = 1:n
            % 计算邻域的范围
            x_start = max(1, i - half_window);
            x_end = min(m, i + half_window);
            y_start = max(1, j - half_window);
            y_end = min(n, j + half_window);
            
            % 提取邻域内的像素值
            neighbor_pixels = image(x_start:x_end, y_start:y_end, :);
            
            % 对每个通道分别计算均值
            for ch = 1:c
                mean_value = mean(neighbor_pixels(:,:,ch), 'all'); % 只对当前通道求平均值
                I_filtered(i, j, ch) = mean_value; % 将平均值赋给对应通道的像素
            end
        end
    end

%中值滤波
function I_filtered = median_filter(I, filter_size) 
    % 检查filter_size是否为正奇数
    if mod(filter_size, 2) == 0 || filter_size <= 0
        error('Filter size must be a positive odd number.');
    end
    
    % 如果是彩色图像，则对每个通道分别进行中值滤波
    if size(I, 3) == 3
        I_filtered = zeros(size(I), 'like', I);
        for c = 1:3
            I_filtered(:, :, c) = medfilt2(I(:, :, c), [filter_size filter_size]);
        end
    else
        % 如果是灰度图像
        I_filtered = medfilt2(I, [filter_size filter_size]);
    end

%高斯滤波
function I_filtered = gaussian_filter(I, window_size, sigma)
    % window_size: 滤波窗口的大小 (如3表示3x3的窗口)
    % sigma: 高斯核的标准差

    % 创建高斯核
    kernel = fspecial('gaussian', window_size, sigma);
    
    % 对图像进行卷积操作
    I_filtered = imfilter(I, kernel, 'same');
    
    % 转换为uint8格式
    I_filtered = uint8(I_filtered);


% --- Executes on button press in pushbutton20.频域滤波
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global J

% 确保图片已加载
if isempty(J)
    msgbox('请先加载一张图片！');
    return;
end

% 弹出选择框让用户选择滤波类型
filter_type = questdlg('选择滤波类型', ...
    '频率滤波', ...
    '低通滤波', '高通滤波', '带通滤波', '低通滤波');

% 根据选择的滤波类型进行处理
switch filter_type
    case '低通滤波'
        filtered_image = frequency_filter(J, 'low');
    case '高通滤波'
        filtered_image = frequency_filter(J, 'high');
    case '带通滤波'
        filtered_image = frequency_filter(J, 'bandpass');
end

% 显示滤波后的图像
axes(handles.axes2);
imshow(filtered_image);

% 频率域滤波函数
function output_image = frequency_filter(input_image, filter_type)
% 将图像转换为灰度图像
gray_image = my_rgb2gray(input_image);

% 将图像转换为频率域（傅里叶变换）
F = fft2(double(gray_image));
Fshift = fftshift(F); % 将零频移到频谱的中心

% 获取频谱的大小
[rows, cols] = size(Fshift);

% 创建频率滤波器
[u, v] = meshgrid(-floor(cols/2):floor(cols/2)-1, -floor(rows/2):floor(rows/2)-1);
D = sqrt(u.^2 + v.^2); % 频率的距离

% 设置截止频率
cutoff_low = 30;  % 低通滤波器的截止频率
cutoff_high = 10; % 高通滤波器的截止频率
cutoff_band = [10, 50]; % 带通滤波器的截止频率范围

switch filter_type
    case 'low'
        % 低通滤波器
        H = double(D <= cutoff_low);
    case 'high'
        % 高通滤波器
        H = double(D >= cutoff_high);
    case 'bandpass'
        % 带通滤波器
        H = double(D >= cutoff_band(1) & D <= cutoff_band(2));
end

% 应用滤波器到频谱
Fshift_filtered = Fshift .* H;

% 将滤波后的频谱转换回空间域
F_filtered = ifftshift(Fshift_filtered);
output_image = ifft2(F_filtered);
output_image = real(output_image); % 取实部作为输出

% 将输出图像的像素值限制在[0, 255]范围内，并转换为uint8类型
output_image = uint8(output_image);
output_image(output_image > 255) = 255;
output_image(output_image < 0) = 0;

% --- Executes on button press in pushbutton9.Robert算子
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I_edge

% 检查图像是否已经加载
if isempty(I)
    msgbox('请先打开一张图片！', '错误', 'error');
    return;
end

% 将图像转换为灰度图（如果是彩色图像）
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);
else
    I_gray = I;
end

% 定义Robert算子的两个卷积核
Gx = [1 0; 0 -1]; % 水平梯度
Gy = [0 1; -1 0]; % 垂直梯度

% 对图像应用Robert算子
Ix = conv2(I_gray, Gx, 'same'); % 水平边缘
Iy = conv2(I_gray, Gy, 'same'); % 垂直边缘

% 计算边缘强度
I_edge = sqrt(Ix.^2 + Iy.^2);

% 显示边缘提取后的图像
axes(handles.axes2)
imshow(I_edge, [0,10]);  % 强制显示在一定范围内
title('Robert算子边缘提取');

% --- Executes on button press in pushbutton10.Prewitt算子
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I_edge

% 检查图像是否已经加载
if isempty(I)
    msgbox('请先打开一张图片！', '错误', 'error');
    return;
end

% 将图像转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);
else
    I_gray = I;
end

% 定义Prewitt算子的两个卷积核
Gx = [1 0 -1; 1 0 -1; 1 0 -1];  % 水平梯度
Gy = [1 1 1; 0 0 0; -1 -1 -1];  % 垂直梯度

% 对图像应用Prewitt算子
Ix = conv2(I_gray, Gx, 'same'); % 水平边缘
Iy = conv2(I_gray, Gy, 'same'); % 垂直边缘

% 计算边缘强度
I_edge = sqrt(Ix.^2 + Iy.^2);


% 显示边缘提取后的图像
axes(handles.axes2)
imshow(I_edge, [0,35]);
title('Prewitt算子边缘提取');

% --- Executes on button press in pushbutton11.Sobel算子
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I_edge

% 检查图像是否已经加载
if isempty(I)
    msgbox('请先打开一张图片！', '错误', 'error');
    return;
end

% 将图像转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);
else
    I_gray = I;
end


% 定义Sobel算子的两个卷积核
Gx = [-1 0 1; -2 0 2; -1 0 1];  % 水平梯度
Gy = [-1 -2 -1; 0 0 0; 1 2 1];  % 垂直梯度

% 对图像应用Sobel算子
Ix = conv2(I_gray, Gx, 'same'); % 水平边缘
Iy = conv2(I_gray, Gy, 'same'); % 垂直边缘

% 计算边缘强度
I_edge = sqrt(Ix.^2 + Iy.^2);


% 显示边缘提取后的图像
axes(handles.axes2)
imshow(I_edge, [0,70]);
title('Sobel算子边缘提取');

% --- Executes on button press in pushbutton21.拉普拉斯算子边缘提取
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I_edge

% 检查图像是否已经加载
if isempty(I)
    msgbox('请先打开一张图片！', '错误', 'error');
    return;
end

% 将图像转换为灰度图
if size(I, 3) == 3
    I_gray = my_rgb2gray(I);
else
    I_gray = I;
end

% 定义拉普拉斯算子的卷积核
L = [0 1 0; 1 -4 1; 0 1 0];

% 对图像应用拉普拉斯算子
I_edge = conv2(I_gray, L, 'same');

% 显示边缘提取后的图像
axes(handles.axes2)
imshow(I_edge, [0,8]);
title('拉普拉斯算子边缘提取');

% --- Executes on button press in pushbutton15.提取图像目标
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I I_edge BW % 获取原始图像和边缘图像
    
    % 检查图像是否已经加载
    if isempty(I)
        msgbox('请先打开一张图片！', '错误', 'error');
        return;
    end

    % 检查是否已经执行过边缘提取
    if isempty(I_edge)
        msgbox('请先进行边缘提取！', '错误', 'error');
        return;
    end
    
    % 使用I_edge作为边缘图像（I_edge是之前的边缘提取结果）
    BW = I_edge;  % 直接使用之前的边缘图像

    % 如果需要对边缘图像进行后续处理（如目标提取），可以继续在这里进行
    % 例如：使用一个阈值将边缘图像二值化（如果它还不是二值图像的话）

    % 存储提取的目标
    handles.BW = BW;  % 保存目标图像
    guidata(hObject, handles);  % 更新handles

    % 显示目标提取后的图像
    axes(handles.axes2);
    imshow(BW);
    title('提取的目标');

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I BW
% 弹出对话框让用户选择操作对象
choice = menu('选择操作对象', '原始图像', '所提取目标');

% 检查用户是否做出了选择（choice 会返回用户选择的索引，取消则返回 0）
if choice == 0
    disp('操作已取消');
    return;
end

% 根据用户选择执行相应的操作
switch choice
    case 1  % 原始图像
        % 提取 LBP 特征
        lbpImage = extractLBPFeatures(I);  % 这里需要您实现或调用提取 LBP 特征的函数
        
        % 显示结果（这里简单显示为示例，可以根据需要处理）
        axes(handles.axes2);  % 假设 axes1 是用于显示结果的坐标轴
        imshow(lbpImage, []);  % 使用 [] 自动调整显示范围
        
    case 2  % 所提取目标
        % 提取 LBP 特征
        lbpTarget = extractLBPFeatures(BW);  % 同样需要实现或调用该函数
        
        % 显示结果
        axes(handles.axes2);
        imshow(lbpTarget, []);
end

% 提取 LBP 特征的函数
function lbpImage = extractLBPFeatures(image)
% 检查输入图像是否为灰度图像
if size(image, 3) == 3
    image = my_rgb2gray(image); % 如果是彩色图像，则转换为灰度图像
end
% 获取图像尺寸
[rows, cols] = size(image);
% 初始化 LBP 特征图像
lbpImage = zeros(rows, cols, 'uint8');
% 定义 3x3 邻域掩码（不包括中心像素）
offsets = [-1 -1; -1 0; -1 1; 0 -1; 0 1; 1 -1; 1 0; 1 1];

% 遍历图像中的每个像素（不包括边缘）
for i = 2:rows-1
    for j = 2:cols-1
        % 获取中心像素值
        center = double(image(i, j));
        % 初始化二进制字符串
        binaryString = '';
        % 遍历邻域像素
        for k = 1:size(offsets, 1)
            % 计算邻域像素的位置
            ni = i + offsets(k, 1);
            nj = j + offsets(k, 2);
            
            % 获取邻域像素值
            neighbor = double(image(ni, nj));
            % 根据邻域像素与中心像素的比较生成二进制字符串
            if neighbor >= center
                binaryString = [binaryString '1'];
            else
                binaryString = [binaryString '0'];
            end
        end
        % 将二进制字符串转换为十进制数（即 LBP 值）
        lbpValue = bin2dec(binaryString);
        
        % 将 LBP 值赋给 LBP 特征图像的对应像素
        lbpImage(i, j) = lbpValue;
    end
end
% 处理图像边缘（边缘像素的 LBP 值可以设为 0 或其他标记值）
lbpImage([1, end], :) = 0;
lbpImage(:, [1, end]) = 0;



% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % 提示用户选择图像进行 HOG 特征提取
    choice = questdlg('请选择要提取 HOG 特征的图像：', ...
                      'HOG 特征提取', ...
                      '原始图像', '所提取目标', '取消', '原始图像');
    
    % 根据用户选择进行操作
    switch choice
        case '原始图像'
            % 检查原始图像是否已加载
            global I
            if isempty(I)
                msgbox('没有加载图像，请先加载图像。');
                return;
            end
            % 从原始图像提取 HOG 特征
            [hog_features, ~] = extractHOGFeatures(I);
            % 将特征数据存储到一个变量中，或用于后续操作
            disp('从原始图像提取的 HOG 特征：');
            disp(hog_features);
            
            % 将提取的特征存储为一个 MATLAB 变量
            handles.hog_features = hog_features;
            guidata(hObject, handles);
            
        case '所提取目标'
            % 检查所提取目标是否已生成
            global BW
            if isempty(BW)
                msgbox('没有所提取目标，请先处理图像。');
                return;
            end
            % 从所提取目标提取 HOG 特征
            [hog_features, ~] = extractHOGFeatures(BW);
            % 将特征数据存储到一个变量中，或用于后续操作
            disp('从所提取目标提取的 HOG 特征：');
            disp(hog_features);
            
            % 将提取的特征存储为一个 MATLAB 变量
            handles.hog_features = hog_features;
            guidata(hObject, handles);
            
        case '取消'
            return; % 用户取消选择时不做任何操作
    end


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
