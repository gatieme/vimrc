GITHUB_COMMIT="删除了主题配置colorscheme solarized, 在多数系统中报错..."


.PHONY	:	github
github :
	git add -A
	git commit -m $(GITHUB_COMMIT)
	git push origin master
