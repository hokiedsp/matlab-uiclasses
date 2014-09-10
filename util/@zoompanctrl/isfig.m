function tf = isfig(~,val)
%ZOOMPANCTRL/ISFIG
%   TF = ISFIG(VAL) returns false if VAL is not a figure handle

tf = isscalar(val) && ishghandle(val,'figure');
