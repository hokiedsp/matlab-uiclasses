function add(obj,H,varargin)
%UIFLOWGRIDCONTAINER/ADD   Add subpanels
%   ADD(OBJ,H) adds HG panel objects given in H to a scalar
%   UIFLOWGRIDCONTAINER object OBJ. If H must be supported panel type.
%   
%   ADD(OBJ,UIPANELEXOBJ) adds the HG objects associated with a
%   UIPANELEX objects to OBJ.
%
%   ADD(OBJ,UIPANELEXOBJ,'ElementProp1Name',ElementProp1Value,...) to 

narginchk(2,inf);
if ~isscalar(obj)
   error('OBJ must be a scalar UIFLOWGRIDCONTAINER object.');
end
if isempty(obj.hg)
   error('OBJ is not associated with any HG object.');
end

if isa(H,'hgwrapper')
   % extract base HG objects from UIPANELEX objects
   H = H.hgbase();
elseif ~all(ishghandle(H))
   error('H must be an array of valid HG or HGWRAPPER objects.');
end

% turn off the layout until all done
al = obj.AutoLayout;
obj.autolayout = false;

% determine if any are already on OBJ.HG
tf = arrayfun(@(c)handle(get(c,'Parent'))==obj.hg,H);

% add existing children to the grid
Hexist = setdiff(H(tf),obj.elem_h); % if already on grid, no need to add
for n = 1:numel(Hexist)
   obj.register_element(Hexist(n));
end

% add non-child H's as children of obj.hg
set(H(~tf),'Parent',obj.GraphicsHandle);

% set properties
if nargin>2
   obj.setelement(H,varargin{:});
end

% reset AutoLayout (which may trigger layout() method)
obj.AutoLayout = al;
