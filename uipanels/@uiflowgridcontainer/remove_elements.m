function remove_elements(obj,h)
%UIFLOWGRIDCONTAINER/REMOVE_ELEMENTS   Remove specified elements
%   REMOVE_ELEMENTS(OBJ,H) removes the HG objects H from the grid defined
%   by OBJ. This function does not call update_grid().

if ~isvalid(obj), return; end

[hremoved,I] = intersect(obj.elem_h,handle(h));
if isempty(hremoved), return; end

% remove their listeners
delete_listeners(obj,hremoved)

% remove them from the grid
obj.elem_h(I,:) = [];
obj.elem_subs(I,:) = [];    % elements' placement subcripts
obj.elem_span(I,:) = [];    % elements' sizes in cells
obj.elem_wlims(I,:) = [];   % elements' width limits
obj.elem_hlims(I,:) = [];   % elements' height limits
obj.elem_halign(I,:) = [];  % elements' horizontal alignment w/in cell
obj.elem_valign(I,:) = [];  % elements' vertical alignment w/in cell
obj.elem_hfixed(I,:) = [];  % elements' fixed height w/in cell
obj.elem_vfixed(I,:) = [];  % elements' fixed width w/in cell
