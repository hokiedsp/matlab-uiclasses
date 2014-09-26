function permute_elements(obj,h)
%UIFLOGRIDCONTAINER/PERMUTE_ELEMENTS   Reorder Elements
%   PERMUTE_ELEMENTS(OBJ,H) reorders OBJ.Elements as given by H. H is
%   expected to be the full permutation of OBJ.elem_h handle vector.

% get the new order
[~,I] = ismember(obj.elem_h,h);

% reorder all Elements properties
obj.elem_h(I) = obj.elem_h;   % HG objects to be included
obj.elem_wlims(I,:) = obj.elem_wlims;   % elements' width limits
obj.elem_hlims(I,:) = obj.elem_hlims;   % elements' height limits
obj.elem_subs(I,:) = obj.elem_subs;    % elements' placement subcripts
obj.elem_span(I,:) = obj.elem_span;    % elements' sizes in cells
obj.elem_halign(I) = obj.elem_halign;  % elements' horizontal alignment w/in cell
obj.elem_valign(I) = obj.elem_valign;  % elements' vertical alignment w/in cell
obj.elem_hfixed(I) = obj.elem_hfixed;   % true to fix elements
obj.elem_vfixed(I) = obj.elem_vfixed;    % true to fix elements
