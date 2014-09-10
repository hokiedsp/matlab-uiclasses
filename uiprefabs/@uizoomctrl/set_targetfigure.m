function f = set_targetfigure(obj,h)
%UIZOOMCTRL/FIGRESET   Target Figure BeingDestroyed callback
%   FIGRESET(OBJ)

% if object is not valid, just exit
if ~isvalid(obj), return; end

if nargin<2 % HG handle not given
   % use the parent of the button handle
   h = struct2array(obj.btns);
   h = h(find(ishghandle(h),1));
end

% call zoompanctrl method
f = obj.set_targetfigure@zoompanctrl(h);
