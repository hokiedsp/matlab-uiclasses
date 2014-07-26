function set_labelposition(obj,type,pos)
%HGANDLABELS/SET_LABELPOSITION
%   SET_LABELPOSITION(OBJ,TYPE,POS)

if obj.istex(type)
   set(obj.htexts(type),'Position',pos([1 2]));
else
   set(obj.hlabels(type),'Position',pos);
end
