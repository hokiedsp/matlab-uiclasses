function pos = get_labelextent(obj,type)
%HGANDLABELS/GET_LABELEXTENT
%   POS = LABELEXTENT(OBJ,TYPE)

if numel(obj.htexts)<type || strcmp(get(obj.htexts(type),'Visible'),'off')
   pos = get(obj.hlabels(type),'Extent');
else
   pos = get(obj.htexts(type),'Extent');
end
