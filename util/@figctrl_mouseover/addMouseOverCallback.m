function addMouseOverCallback(obj,h,cbfcn)
%FIGCTRL_MOUSEOVER/ADDMOUSEOVERCALLBACK   Add HG object mouse over callback function
%   ADDMOUSEOVERCALLBACK(OBJ,H,CBFCN) adds mouse over callback function
%   given in function handle CBFCN for an object H in the associated
%   figure.
%
%   The mouse over callback takes one parameter with 2-element mouse
%   pointer coordinate [x y]:
%
%      CBFCN(current_point)
%
%   If H is a child of an axes, current_point is 2x3 matrix given by the
%   instantaneous value of the axes' CurrentPoint property. Otherwise,
%   current_point is an 2-element vector [x y] given by the parent figure's
%   CurrentPoint property. Note that the unit of figure's current_point is
%   as specified by the figure's Units property.
%
%   See also: FIGCTRL_MOUSEOVER, FIGCTRL_MOUSEOVER/FIGCTRL_MOUSEOVER,
%             FIGCTRL_MOUSEOVER/REMOVEMOUSEOVERCALLBACK,
%             FIGCTRL_MOUSEOVER/SETCURRENTPOINTERASDEFAULT.

narginchk(3,3);

if ~isscalar(obj)
   error('ADDMOUSEOVERCALLBACK cannot be called for non-scalar %s array.',class(obj));
end

if ~isvalid(obj)
   error('Invalid FIGCTRL_MOUSEOVER object,');
end

if isempty(h), return; end % nothing to do if h is empty

h = handle(h);

fig = handle(obj.wbmf_mode.GraphicsHandle);

if ~(isscalar(h) && ishghandle(h) && handle(ancestor(h,'figure'))==fig)
   error('H must be a valid HG object which is descendent of the attached figure object.');
end

if ~isa(cbfcn,'function_handle')
   error('CBFCN must be a function handle.');
end

% check if the requested HG object already exists
I = obj.h==h;
if ~any(I) % new entry
   I = numel(I)+1;
   obj.h(I,1) = h;
   obj.el(I,1) = addlistener(h,'ObjectBeingDestroyed',obj.killfcn);
end

% register the callback function
obj.cbfcns{I,1} = cbfcn;
