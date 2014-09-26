function setcounterformat(obj,val)
%UIVIDEOVIEWER/SETCOUNTERFORMAT

obj.txformat = val;
[fmt,type] = obj.getCounterFormat();
obj.txfmtfcn = @(data)sprintf(fmt,data{type});

% update frame
if obj.isopen()
   obj.setcurrentframe();
end
