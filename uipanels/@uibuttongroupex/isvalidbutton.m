function tf = isvalidbutton(h)
%UIBTNGROUPEX/ISVALIDBUTTON   true for valid button HG object.
%   ISVALIDBUTTON(H) returns an array that contains trues where the
%   elements of H are handles to existing radiobutton or togglebutton
%   uicontrol objects and 0s where they are not.

sz = size(h);

tf = ishghandle(h) ...
   & reshape(strcmp(get(h,{'Type'}),'uicontrol') ...
       & cellfun(@(style)any(strcmp(style,{'radiobutton','togglebutton'})),get(h,{'Style'})),sz);
    