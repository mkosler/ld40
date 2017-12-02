return {
    map = function (t, f, ...)
        local nt = {}
        for k,v in ipairs(t) do
            if type(f) == 'string' then
                nt[k] = v[f](v, ...)
            else
                nt[k] = f(v, ...)
            end
        end
        return nt
    end
}