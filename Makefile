all:
	lua extract.lua
	elpi -test hm.elpi hm-main.elpi