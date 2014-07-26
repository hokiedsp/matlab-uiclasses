function c = match_bgcolor(obj,p,pname)
%HGANDLABELS/MATCH_BGCOLOR
%   c = MATCH_BGCOLOR(OBJ,p,pname)

c = obj.match_bgcolor@hgdisguise(p,pname);

try
   set(obj.labels_h,'BackgroundColor',c);
catch
end