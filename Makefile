all: test-hm

hm.elpi:
	lua extract.lua

test-hm: hm.elpi
	elpi -test hm-main.elpi 2>err 1>out
	test `grep 'result'    out | grep -F 'mono (list X0 --> bool)' out | wc -l` = 1
	test `grep 'suspended' err | wc -l` = 2
	test `grep 'suspended' err | grep -F 'theta [X0]' | wc -l` = 1
	test `grep 'suspended' err | grep -F 'of c0 (all tt c1 \\ mono (list c1 --> bool)) ?- eqbar X0' | wc -l` = 1