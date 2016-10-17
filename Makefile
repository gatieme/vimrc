GITHUB_COMMIT="vimrc中增加了对鼠标的支持, gvim下鼠标右键支持菜单显示..."


.PHONY	:	github
github :
	git add -A
	git commit -m $(GITHUB_COMMIT)
	git push origin master
