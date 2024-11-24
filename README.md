# JPEG-PNG2YUV444
将 JPEG/PNG 图像转换为 YUV444 (BT.2020 Full Range) 的 MATLAB 实现
### **将 JPEG/PNG 图像转换为 YUV444 (BT.2020 Full Range) 的 MATLAB 实现**

在数字图像处理领域，YUV 格式广泛应用于视频编码、传输和显示设备中。尤其是在 ISP（图像信号处理）中，YUV 格式是重要的中间表达。本文将介绍一个使用 MATLAB 将 JPEG/PNG 图像转换为 YUV444 (BT.2020 Full Range) 格式的完整实现，并生成对应的 `.yuv` 文件。

---

#### **YUV 格式简介**
- **YUV444** 是一种未压缩的格式，表示每个像素都有完整的亮度（Y）和色度（U、V）信息。
- **BT.2020 Full Range** 定义了一种广色域、全范围的标准，适用于 HDR（高动态范围）视频。
  - Y：亮度分量，范围 `[0, 255]`。
  - U/V：色度分量，范围 `[-128, 127]`，但为了文件存储方便，常偏移到 `[0, 255]`。

---

#### **MATLAB 代码实现**

以下代码可以读取任意 JPEG/PNG 格式的 RGB 图像，将其转换为 YUV444 格式，并按照 BT.2020 Full Range 的标准生成 `.yuv` 文件。

##### **代码示例**
```matlab
function convert_and_verify_image(input_file, output_file, width, height)
    % 功能：将 JPEG/PNG 图像转换为 YUV444 (BT.2020 Full Range)
    % 参数：
    %   input_file: 输入图片文件路径 (e.g., 'image.jpg', 'image.png')
    %   output_file: 输出 YUV 文件路径 (e.g., 'output.yuv')
    %   width: 图片宽度
    %   height: 图片高度

    % ---- 第 1 部分：RGB 转 YUV ----
    % 读取输入图片
    img = imread(input_file);

    % 确保是 RGB 图像
    if size(img, 3) ~= 3
        error('输入图片必须是 RGB 图像！');
    end

    % 转换为双精度浮点数，方便计算
    img = double(img);

    % 提取 R、G、B 分量
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);

    % 使用 BT.2020 Full Range 的转换公式
    Y = 0.2627 * R + 0.6780 * G + 0.0593 * B;
    U = -0.1396 * R - 0.3604 * G + 0.5000 * B;
    V = 0.5000 * R - 0.4598 * G - 0.0402 * B;

    % 映射到 [0, 255] 范围
    Y = uint8(Y);           % Y 分量范围 [0, 255]
    U = uint8(U + 128);     % U 分量范围 [-128, 127] 偏移到 [0, 255]
    V = uint8(V + 128);     % V 分量范围 [-128, 127] 偏移到 [0, 255]

    % 将 YUV 分量保存为 YUV444 文件
    fid = fopen(output_file, 'wb');
    fwrite(fid, Y', 'uint8'); % 写入 Y 分量（逐行）
    fwrite(fid, U', 'uint8'); % 写入 U 分量（逐行）
    fwrite(fid, V', 'uint8'); % 写入 V 分量（逐行）
    fclose(fid);

    fprintf('YUV444 文件已生成：%s\n', output_file);
end
```

---

#### **代码解读**

1. **参数说明**：
   - `input_file`：输入图片路径，支持 `.jpg` 或 `.png` 格式。
   - `output_file`：输出 `.yuv` 文件路径，格式为 YUV444。
   - `width` 和 `height`：图片分辨率，用于生成和验证 YUV 数据。

2. **核心算法**：
   - **RGB 转 YUV**：使用 BT.2020 Full Range 标准的转换公式：
     \[
     Y = 0.2627R + 0.6780G + 0.0593B
     \]
     \[
     U = -0.1396R - 0.3604G + 0.5000B
     \]
     \[
     V = 0.5000R - 0.4598G - 0.0402B
     \]
   - 色度分量 \( U, V \) 经过偏移处理，映射到 `[0, 255]` 范围。

3. **文件保存**：
   - 数据以 `YUV444` 格式逐行写入，每个分量占用一个字节，总大小为 `宽度 × 高度 × 3` 字节。

---

#### **使用示例**

假设输入图片为 `test_image.png`，图片分辨率为 `1920x1080`，输出文件名为 `output_bt2020.yuv`，运行以下代码：

```matlab
convert_and_verify_image('test_image.png', 'output_bt2020.yuv', 1920, 1080);
```

运行后，程序将生成文件 `output_bt2020.yuv`。

---

#### **结果分析**

1. 输出文件：
   - `output_bt2020.yuv` 是一个未压缩的 YUV444 格式文件，可直接用于视频编码或 ISP 算法调试。
   
2. 验证转换：
   - 如果需要验证生成的 YUV 数据，可扩展代码，将 YUV 转回 RGB，并与原始图片进行对比。

---

#### **总结**

本文提供的 MATLAB 脚本可以帮助用户快速实现 JPEG/PNG 图像到 YUV444 格式的转换，支持 BT.2020 Full Range 标准，适用于 ISP 图像处理和视频处理开发。通过该代码，您可以轻松生成测试所需的 YUV 数据，并将其用于各种图像处理算法的开发与验证。

如果您对代码有任何问题，欢迎留言讨论！
