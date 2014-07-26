function set_labelstring(obj,type,str)
%HGANDLABELS/SET_LABELSTRING
%   SET_LABELSTRING(OBJ,TYPE,STR)

if isempty(str)
   vis = 'off';
else
   vis = 'on';
end

if obj.istex(type)
   set(obj.htexts(type),'String',str,'Visible',vis);
else
   set(obj.hlabels(type),'Visible',vis);
end
set(obj.hlabels(type),'String',str)

if (type==1 && obj.autosize_lead) || (type==2 && obj.autosize_rear)
   obj.adjust_labelposition(type);
end
