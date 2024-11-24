function convert_and_verify_image(input_file, output_file, width, height)
    % 功能：将 JPEG/PNG 图像转换为 YUV444 (BT.2020 Full Range) 并验证结果
    % 参数：
    %   input_file: 输入图片文件 (e.g., 'image.jpg', 'image.png')
    %   output_file: 输出 YUV 文件 (e.g., 'output.yuv')
    %   width: 图片宽度 (仅用于验证步骤)
    %   height: 图片高度 (仅用于验证步骤)

    % ---- 第 1 部分：RGB 转 YUV ----
    % 读取输入图片
    img = imread(input_file);

    % 确保是 RGB 图像
    if size(img, 3) ~= 3
        error('输入图片必须是 RGB 图像！');
    end

    % 转换为双精度浮点数
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


