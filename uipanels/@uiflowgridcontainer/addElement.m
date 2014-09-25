function addElement(obj,H,varargin)
%UIFLOWGRIDCONTAINER/ADDELEMENT   Add new element to the container
%   ADDELEMENT(OBJ,H) adds HG panel objects given in H to a scalar
%   UIFLOWGRIDCONTAINER object OBJ. If H must be supported panel type.
%   
%   ADDELEMENT(OBJ,UIPANELEXOBJ) adds the HG objects associated with a
%   UIPANELEX objects to OBJ.
%
%   ADDELEMENT(OBJ,UIPANELEXOBJ,'ElementProp1Name',ElementProp1Value,...) to 

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
al = obj.autolayout;
obj.autolayout = false;

% determine if any are already on OBJ.HG
tf = arrayfun(@(c)handle(get(c,'Parent'))==obj.hg,H);

% add existing children to the grid
Hexist = setdiff(H(tf),obj.elem_h); % if already on grid, no need to add
for n = 1:numel(Hexist)
   obj.add_element(Hexist(n));
end

% add non-child H's as children of obj.hg
try
   set(H(~tf),'Parent',obj.GraphicsHandle);
catch
   error('At least one element of H cannot be an immediate child of UIFLOWCONTAINER.');
end

% set properties
if nargin>2
   obj.setElement(H,varargin{:});
end

% reset AutoLayout flag
obj.autolayout = al;

% update grid
obj.update_grid();
