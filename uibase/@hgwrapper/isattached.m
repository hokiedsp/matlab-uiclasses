function tf = isattached(obj)

tf = ~arrayfun(@(o)isempty(o.hg),obj);

end
