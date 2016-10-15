GITHUB_COMMIT="增加了vimrc对gui的支持, 增加了通用的myshrc.sh配置脚本..."


.PHONY	:	github
github :
	git add -A
	git commit -m $(GITHUB_COMMIT)
	git push origin master
