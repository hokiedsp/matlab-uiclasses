function c = match_bgcolor(obj,p,pname)
%HGANDLABELS/MATCH_BGCOLOR   
%   C = MATCH_BGCOLOR(OBJ,p,propname)

c = get(p,pname);
set(obj.hpanel,'BackgroundColor',c);
