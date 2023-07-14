##**************************************************************************
## Copyright (C)  2021-2025 CHIPSTACKS All rights reserved.
## -------------------------------------------------------------------------
## This document contains proprietary information belonging to CHIPSTACKS.
## Passing on and copying of this document, use and communication of its
## contents is not permitted without prior written authorisation.
## -------------------------------------------------------------------------
## Revision Information :
##    File name: replace.sh
##    Version: 0.1 Bryan.Tian
##    Date:   2023-7-12
##
##***************************************************************************

#!/bin/bash
#-------------------------------------------------------------------------
#  author:Bryan.Tian
#  匹配并替换C文件中的变量名和函数名
#-------------------------------------------------------------------------

#确认待处理的多个文件
source="$@"

#利用astyle进行标准化处理
astyle $source

# 匹配C文件中的变量名
grep -oh  '[a-zA-Z_][a-zA-Z0-9_ ]*=' $source | sort | uniq | sed 's/=$//' |awk '{print $NF}' >var_names.txt

#匹配C文件中的函数名
grep -ohE  '^[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*[\*]*[a-zA-Z_][a-zA-Z0-9_]*\(' $source | awk '{print $NF}' | sed 's/($//'> func_names.txt
#grep -o：只输出匹配到的部分。-E：使用扩展的正则表达式进行匹配。'^[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\('：正则表达式用于匹配具有一定格式的函数声明。它匹配以字母或下划线开头的函数返回类型，后跟一个或多个字母、数字或下划线的函数名，然后是零或多个空格，最后以括号 "(" 结尾。这样的匹配会输出整个函数声明。
#awk：用于对输入进行文本处理的命令。'{print $NF}'：打印每行的最后一个字段。在这种情况下，由于之前的grep命令匹配到整个函数声明，因此这个命令将提取函数声明中的最后一个字段，即函数名。
#sed：用于进行文本替换和编辑的命令。's/($//'：替换每行中的 "(" 符号为空字符串，从而去除函数名后面的括号。

#保证函数名和变量名的首字符符合规则
first_char=$(cat /dev/urandom | tr -dc 'a-zA-Z_' | fold -w 1 | head -n 1)

#产生替换的变量名
cat var_names.txt | while IFS= read -r line
do
	var_length=${#line}
	temp_replace_var=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$var_length" | head -n 1)
	replace_var="$first_char$temp_replace_var"
	#cat /dev/urandom：/dev/urandom 是 Linux 系统中的一个伪随机数生成设备。通过使用 cat 命令读取 /dev/urandom，我们可以获取随机的字节序列。
	#tr -dc 'a-zA-Z0-9'：tr 命令用于字符转换或删除操作。在这里，我们使用 -dc 选项指定要删除的字符集，即只保留字母和数字字符。
	#fold -w "$length"：fold 命令用于将文本进行折行处理。使用 -w 选项指定每行的最大宽度为 $length，即指定生成的随机字符串的长度。
	#head -n 1：head 命令用于显示文件的开头部分。通过使用 -n 1 选项，我们只显示第一行，即生成的随机字符串
	var_sed_rules="s/\<$line\>/$replace_var/g"
	echo  $var_sed_rules
done >var_sed_rules.txt

#产生替换的函数名

cat func_names.txt | while IFS= read -r line
do
	func_length=${#line}
	temp_replace_function=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$func_length" | head -n 1)
	replace_function="$first_char$temp_replace_function"
	#cat /dev/urandom：/dev/urandom 是 Linux 系统中的一个伪随机数生成设备。通过使用 cat 命令读取 /dev/urandom，我们可以获取随机的字节序列。
	#tr -dc 'a-zA-Z0-9'：tr 命令用于字符转换或删除操作。在这里，我们使用 -dc 选项指定要删除的字符集，即只保留字母和数字字符。
	#fold -w "$length"：fold 命令用于将文本进行折行处理。使用 -w 选项指定每行的最大宽度为 $length，即指定生成的随机字符串的长度。
	#head -n 1：head 命令用于显示文件的开头部分。通过使用 -n 1 选项，我们只显示第一行，即生成的随机字符串
	func_sed_rules="s/\<$line\>/$replace_function/g"
	echo  $func_sed_rules
done >func_sed_rules.txt

#合并sed规则文件
cat  func_sed_rules.txt var_sed_rules.txt >sed_rules.txt
#############################################################################################################################
#保证主函数名不被替换
sed -i '/\<main\>/d' sed_rules.txt

#h保证头文件的后缀不被替换
sed -i '/\<[h]\>/d' sed_rules.txt

#nsdft代表\n\s\d\f\t 保证换行、字符串、十进制、十六进制等单个敏感字符不被替换
sed -i '/\<[hnsdft]\>/d' sed_rules.txt

#保证纯数字不被替换
sed -i '/\<[0-9]*\>/d' sed_rules.txt

#保证关键字不被替换
sed -i '/\b\(\(\<auto\>\|\<double\>\|\<int\>\|\<struct\>\|\<break\>\|\<else\>\|\<long\>\|\<switch\>\|\<case\>\|\<enum\>\|\<register\>\|\<typedef\>\|\<char\>\|\<extern\>\|\<return\>\|\<union\>\|\<const\>\|\<float\>\|\<short\>\|\<unsigned\>\|\<continue\>\|\<for\>\|\<signed\>\|\<void\>\|\<default\>\|\<goto\>\|\<volatile\>\|\<do\>\|\<if\>\|\<static\>\|\<while\>\)\)\b/d' sed_rules.txt

#保证一些预定义的宏和变量不被替换
sed -i '/\b\(\(\<NULL\>\|\<EOF\>\|\<true\>\|\<false\>\)\)\b/d' sed_rules.txt

#保证标准的库函数和变量不被替换 printf、scanf、malloc、free、strlen、sizeof
sed -i '/\b\(\(\<printf\>\|\<scanf\>\|\<malloc\>\|\<free\>\|\<strlen\>\|\<sizeof\>\)\)\b/d' sed_rules.txt

#保证用户定义的类型名不被替换 struct、enum、typedef
sed -i '/\b\(\(\<struct\>\|\<enum\>\|\<typedef\>\)\)\b/d' sed_rules.txt
#############################################################################################################################


#利用sed规则文件逐个处理待处理的文件
for file in $source
do
	echo 当前处理文件:$file
	sed -i -f sed_rules.txt $file
done

###############################################################################################
#删除临时文件
 rm var_names.txt func_names.txt
 rm func_sed_rules.txt var_sed_rules.txt 
 rm sed_rules.txt
###############################################################################################
