##**************************************************************************
## Copyright (C)  2021-2025 CHIPSTACKS All rights reserved.
## -------------------------------------------------------------------------
## This document contains proprietary information belonging to CHIPSTACKS.
## Passing on and copying of this document, use and communication of its
## contents is not permitted without prior written authorisation.
## -------------------------------------------------------------------------
## Revision Information :
##    File name: uglify.sh
##    Version: 0.1 Bryan.Tian
##    Date:   2023-7-12
##
##***************************************************************************


#!/bin/bash

#待处理文件所在路径
file_path="$1"

#利用find命令查找所有的C文件和头文件并执行变量名和函数名的丑化
find $file_path -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" \) | xargs bash replace.sh

#利用find命令查找所有的C文件和头文件并执行格式的丑化
find $file_path -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" \) | xargs bash layout.sh

#make时允许编译过程中出现未使用值的警告而不将其视为错误
find $file_path -type f -name "makefile"| xargs sed -i '/^WARNINGS/ a -Wno-unused-value -Wno-unused-variable \\'

echo Uglify完成