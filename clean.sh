if [ "$1" != '-f' ] && [ ! -e .git ]; then
	echo 'Aborted because not at the root of a repo'
	echo 'You can use "clean -f" to force clean'
	exit 0
fi

echo 'File removed:'

# 用 * 作为搜索路径可以忽略隐藏文件
# 需要为 find 指定 -regextype 为 gnu-awk 才支持括号匹配
# find 的正则匹配的是文件的相对路径，所以要在最前面加 .*
find * -type d -name '__pycache__' -delete -print
find * -regextype gnu-awk -regex '.*\.(tmp|exe|out|txt|class|in|jar|Identifier)' -delete -print
