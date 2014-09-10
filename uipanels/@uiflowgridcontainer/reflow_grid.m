function reflow_grid(obj,new_gridsize)
%UIFLOWGRIDCONTAINER/REFLOW_GRID
%   REFLOW_GRID(OBJ,NEW_GRIDSIZE)

obj.gridsize = new_gridsize;

Nel = obj.NumberOfElements;

% clear the grid map
obj.map = zeros(new_gridsize);

% too small, expand the grid
obj.elem_subs = obj.nextcellsubs(Nel);

% reset weights
obj.vweight = ones(obj.gridsize(1),1);
obj.hweight = ones(obj.gridsize(2),1);
