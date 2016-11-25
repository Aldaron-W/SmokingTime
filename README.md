# SmokingTime
自动运行Pod install，并在执行之后自动打开Xcode进行Build的脚本（说白了就是懒.......）


# 使用方式
- 将文件拷贝到与Podfile相同的目录下
- 为脚本添加执行的权限 (chmod +x SmokingTime.sh)
- 执行脚本（./SmokingTime.sh）

奏是这么简单

# 参数
- --no-pod 跳过Pod阶段
- --no-build 跳过Build阶段
- --run 将Build操作改成Run操作（如果输入了--no-build参数的话，那么这个参数就无效了）
