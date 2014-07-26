function update_grid(obj)
%UIFLOWGRIDCONTAINER/UPDATE_GRID
%   UPDATE_GRID(OBJ) shall be called when the GridSize, Elements,
%   ElementsLocation, or ElementsSpan property is changed either directly
%   or indirectly. UPDATE_GRID updates OBJ.map private property, which
%   carries information on which cell is occupied by which element.

if isempty(obj.elem_h)
   obj.map = zeros(obj.gridsize);
   return;
end

% Make sure the grid is large enough for all its elements
obj.gridsize(:) = max(obj.gridsize,max(obj.elem_subs + obj.elem_span - 1));

% Recreate the grid map
N = numel(obj.elem_h);
obj.map = zeros(obj.gridsize);
for n = 1:N
   % get columns & rows that the element occupies
   I = obj.elem_subs(n,1):(obj.elem_subs(n,1)+obj.elem_span(n,1)-1);
   J = obj.elem_subs(n,2):(obj.elem_subs(n,2)+obj.elem_span(n,2)-1);
   
   % mark the cells that the element occupies
   obj.map(I,J) = n;
end

% done, now compute the limits of grid columns and rows
obj.update_gridlims();
