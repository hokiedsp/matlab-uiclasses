function removeMouseOverCallback(obj,h)
%FIGCTRL_MOUSEOVER/REMOVEMOUSEOVERCALLBACK   Remove HG object mouse over callback function
%   REMOVEMOUSEOVERCALLBACK(OBJ,H) removes mouse over callback function for
%   the HG object with handle H.
%
%   See also: FIGCTRL_MOUSEOVER, FIGCTRL_MOUSEOVER/FIGCTRL_MOUSEOVER, FIGCTRL_MOUSEOVER/ADDMOUSEOVERCALLBACK.

narginchk(2,2);

if ~isscalar(obj) || ~isvalid(obj)
   error('OBJ must be a valid scalar object.');
end

if isempty(h), return; end % nothing to do if obj invalid or h is empty

if ~(ishghandle(h) && isscalar(h))
   error('H must be a scalar HG handle.');
end

obj.kill_monitor(handle(h));
