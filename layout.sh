##**************************************************************************
## Copyright (C)  2021-2025 CHIPSTACKS All rights reserved.
## -------------------------------------------------------------------------
## This document contains proprietary information belonging to CHIPSTACKS.
## Passing on and copying of this document, use and communication of its
## contents is not permitted without prior written authorisation.
## -------------------------------------------------------------------------
## Revision Information :
##    File name: layout.sh
##    Version: 0.1 Andy.cao
##    Date:   2023-7-12
##
##***************************************************************************

#!/bin/bash

for file in "$@"
do
#确认待处理文件
source=$file
#将处理文件进行格式标准化
#astyle $source

countline=0
# -------------------------------------------------------------------------
 # author:Andy.cao
 # 随机删除注释
# -------------------------------------------------------------------------

# # 使用Python脚本删除注释
python3 - <<EOF
import re
import random

# 读取C文件内容
with open("$source", "r") as file:
    content = file.read()

# 正则表达式匹配注释
pattern = r"(//.*?$|/\*[\s\S]*?\*/)"

def replace_comment(match):
    if random.random() < 0.5:  # 50%的概率删除注释
        return ""  # 删除注释
    else:
        return match.group()  # 保留注释

# 随机删除注释
content = re.sub(pattern, replace_comment, content, flags=re.MULTILINE)

# 删除连续的多个空行
content = re.sub(r'\n\s*\n', '\n', content)

# 保存修改后的文件
with open("$source", "w") as file:
    file.write(content)

EOF

#-------------------------------------------------------------------------
#  author:Andy.cao
#  插入各种花指令
#-------------------------------------------------------------------------


#显示函数体的函数名所在的行号
function_name_line=$(grep -n -E '^[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*\(' $source | sed '/\;$/d' | cut -d ':' -f 1)

for line_num in $function_name_line
do
 # 生成一个随机数（范围：0到1）
 random_number=$((RANDOM % 2))
 # 插入随机判断
 if [ $random_number -eq 1 ]; then

  processed_line=$line_num
  # 输出处理后的数组 
  # 生成第二个随机数（范围：0到4）
  random_number1=$((RANDOM % 5))
	  # 利用随机数进行判断花指令类型
	  case $random_number1 in
		  0)
			#插入花指令
			line_number=$((processed_line+countline+2)) # 要插入花指令的起始行号
			message1="	while(0)"
			message2="		{"
			message3="		int abcd = 1, dcba = 128;"
			message4="		for(abcd;abcd<10;abcd++)"
			message5="			{"
			message6="				dcba+=2;"
			message7="			}"
			message8="		}"

			#构建要插入的多行花指令
			insert_lines="${message1}\n"
			insert_lines+="${message2}\n"
			insert_lines+="${message3}\n"
			insert_lines+="${message4}\n"
			insert_lines+="${message5}\n"
			insert_lines+="${message6}\n"
			insert_lines+="${message7}\n"
			insert_lines+="${message8}"

			#在指定行之前插入多行花指令
			sed -i "${line_number}i ${insert_lines}" $source 
			((countline+=8))
			;;
		  1)
			#插入花指令
			line_number=$((processed_line+countline+2)) # 要插入花指令的起始行号
			message1="/*This code seems to have an error.*/"

			#构建要插入的多行花指令
			insert_lines="${message1}"

			#在指定行之前插入多行花指令
			sed -i "${line_number}i ${insert_lines}" $source
			((countline+=1))
			;;
		  2)
			#插入花指令
			line_number=$((processed_line+countline+2)) # 要插入花指令的起始行号
			message1="	do"
			message2="		{"
			message3="		int suspect = 1, certain = 256;"
			message4="		for(suspect;;suspect++)"
			message5="			{"
			message6="				certain+=suspect;"
			message7="			}"
			message8="		}while(0);"

			#构建要插入的多行花指令
			insert_lines="${message1}\n"
			insert_lines+="${message2}\n"
			insert_lines+="${message3}\n"
			insert_lines+="${message4}\n"
			insert_lines+="${message5}\n"
			insert_lines+="${message6}\n"
			insert_lines+="${message7}\n"
			insert_lines+="${message8}"

			#在指定行之前插入多行花指令
			sed -i "${line_number}i ${insert_lines}" $source
			((countline+=8))
			;;
		  3)
			#插入花指令
			line_number=$((processed_line+countline+2)) # 要插入花指令的起始行号
			message1="/*Warning:*/"
			message2="/*This is just a joke.*/"
			message3="/*You were deceived.*/"

			#构建要插入的多行花指令
			insert_lines="${message1}\n"
			insert_lines+="${message2}\n"
			insert_lines+="${message3}"
			
			#在指定行之前插入多行花指令
			sed -i "${line_number}i ${insert_lines}" $source
			((countline+=3))
			;;
		  4)
			#插入花指令
			line_number=$((processed_line+countline+2)) # 要插入花指令的起始行号
			message1="	int bookhad = 1;"
			message2="		if(bookhad = 0)"
			message3="			{"
			message4="				for(int i = 1;i < 100;i++)"
			message5="				{"
			message6="					bookhad+=0;"
			message7="				}"
			message8="			}else"
			message9="			{"
			message10="				bookhad-=0;"
			message11="			}"

			#构建要插入的多行花指令
			insert_lines="${message1}\n"
			insert_lines+="${message2}\n"
			insert_lines+="${message3}\n"
			insert_lines+="${message4}\n"
			insert_lines+="${message5}\n"
			insert_lines+="${message6}\n"
			insert_lines+="${message7}\n"
			insert_lines+="${message8}\n"
			insert_lines+="${message9}\n"
			insert_lines+="${message10}\n"
			insert_lines+="${message11}"

			#在指定行之前插入多行花指令
			sed -i "${line_number}i ${insert_lines}" $source
			((countline+=11))
			;;
		esac
  
	else
 
  # 生成一个新的随机数
  random_number=$((RANDOM % 2)) 
	fi
 
done

#-------------------------------------------------------------------------
#  author:Andy.cao
#  随机删除空行
#-------------------------------------------------------------------------

countzeroline=0
# 使用grep命令匹配所有空行，并将结果存储在空行列表中
empty_lines=($(grep -n '^$' $source | cut -d ':' -f 1))

# 循环处理每个空行
for line_number in "${empty_lines[@]}"; do
    # 生成一个随机数（范围：1到2）
    random_number=$((1 + RANDOM % 2))
    # 根据随机数决定是否删除当前空行
    if [ $random_number -eq 2 ]; then
        # 使用sed命令删除当前空行并覆盖原始文件
		deletline=$((line_number-countzeroline))
        sed -i "${deletline}d" $source
		countzeroline=$((countzeroline+1))
    fi
done

#-------------------------------------------------------------------------
#  author:Andy.cao
#  随机删除行首空格
#-------------------------------------------------------------------------

# 指定临时文件路径
tmp_file="$file.tmp"

# 删除行前的所有空格并在行首插入随机数量的空格
modify_line() {
    local line="$1"
    local trimmed_line="${line##*([[:space:]])}"
    local random_spaces=$(( (RANDOM % 40) ))
    local new_line="$(printf "%${random_spaces}s")$trimmed_line"
    echo "$new_line"
}

# 创建临时文件
touch "$tmp_file"

# 读取文件行并处理
while IFS= read -r line; do
    modified_line=$(modify_line "$line")
    echo "$modified_line" >> "$tmp_file"
done < $1

# 将临时文件替换为原始文件
mv "$tmp_file" $1

done
