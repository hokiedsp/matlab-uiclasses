function update_grid(obj)
%UIFLOWGRIDCONTAINER/UPDATE_GRID
%   UPDATE_GRID(OBJ) shall be called when the GridSize, Elements,
%   ElementsLocation, or ElementsSpan property is changed either directly
%   or indirectly. UPDATE_GRID updates OBJ.map private property, which
%   carries information on which cell is occupied by which element.

% Initialize grid map to zeros
obj.map = zeros(obj.gridsize);

% Make sure the grid is large enough for all its elements
if ~isempty(obj.elem_h)
   obj.gridsize(:) = max(obj.gridsize,max(obj.elem_subs + obj.elem_span - 1));
end

% Check & update weight vectors
N = numel(obj.vweight);
if N==0
   obj.vweight = 1;
elseif N~=obj.gridsize(1)
   vweight = obj.vweight;
   vweight(N+1:obj.gridsize(1),1) = mean(vweight);
   vweight(obj.gridsize(1)+1:end,1) = [];
   obj.vweight = vweight;
end
N = numel(obj.hweight);
if N==0
   obj.hweight = 1;
elseif N~=obj.gridsize(2)
   hweight = obj.hweight;
   hweight(N+1:obj.gridsize(2),1) = mean(hweight);
   hweight(obj.gridsize(2)+1:end,1) = [];
   obj.hweight = hweight;
end

% Recreate the grid map
for n = 1:numel(obj.elem_h)
   % get columns & rows that the element occupies
   I = obj.elem_subs(n,1):(obj.elem_subs(n,1)+obj.elem_span(n,1)-1);
   J = obj.elem_subs(n,2):(obj.elem_subs(n,2)+obj.elem_span(n,2)-1);
   
   % mark the cells that the element occupies
   obj.map(I,J) = n;
end

% force to re-layout the grid
al = obj.autolayout;
obj.autolayout = true;
try
   obj.layout_panel();
   obj.autolayout = al;
catch ME
   obj.autolayout = al;
   ME.rethrow();
end
