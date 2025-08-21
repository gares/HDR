f = io.open('hdr.tex')
known = {}
cur = nil
mode = "skip"
n = 1
for l in f:lines() do
    n = n + 1
    if mode == "skip" then
        local out = l:match('%elpi:([^ ]+)')
        if out ~= nil then
            mode = "spit"
            if known[out] then
                cur = io.open(out,"a")
            else
                cur = io.open(out,"w")
            end
            known[out] = true
        end
    elseif mode == "spit" then
        if l:match('\\end{elpicode') then
            mode = "skip"
            cur:close()
        elseif l:match('\\begin{elpicode') then
            cur:write('#line ',n,' "hdr.tex"\n')
        else
            cur:write(l:gsub('~ ~',''),'\n')
        end
    end
end