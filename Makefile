all: test-hm

hm.elpi: hdr.tex
	lua extract.lua

test-hm: hm.elpi
	elpi -no-det hm-main.elpi -exec test -- 1 2>err 1>out
	test `grep 'result'    out | grep -F 'mono (list X0 --> bool)' out | wc -l` = 1
	test `grep 'suspended' err | wc -l` = 2
	test `grep 'suspended' err | grep -F 'theta [X0]' | wc -l` = 1
	test `grep 'suspended' err | grep -F 'of c0 (all tt c1 \\ mono (list c1 --> bool)) ?- eqbar X0' | wc -l` = 1
	#
	elpi -no-det hm-main.elpi -exec test -- 2 2>err 1>out
	test `grep 'result'    out | grep -F 'mono (pair bool bool)' out | wc -l` = 1
	test `grep 'suspended' err | grep -F 'theta [int, bool]' | wc -l` = 1
	#
	elpi -no-det hm-main.elpi -exec test -- 3 2>err 1>out
	test `grep 'result'    out | grep -F 'mono (pair bool bool)' out | wc -l` = 1
	test `grep 'suspended' err | wc -l` = 2
	test `grep 'suspended' err | grep -F 'theta [int, X0]' | wc -l` = 1
	test `grep 'suspended' err | grep -F 'of c0 (all tt c1 \\ mono (list c1 --> bool)) ?- eqbar X0' | wc -l` = 1