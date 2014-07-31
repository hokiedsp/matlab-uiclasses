function pv = getElement(obj,h,pn)
%UIFLOWGRIDCONTAINER/SETELEMENT
%   V = GETELEMENT(OBJ,H,'PropName')
%   V = GETELEMENT(OBJ,SUBS,'PropName')
%
% Location     % [row column] element's location on the grid ([1 1] is at the upper-left-corner).
% Span         % How many grid cells to occupy: each row [nrows ncols]
% HeightLimits % height limits in pixels, each row: [min max]
% WidthLimits  % width limits in pixels, each row: [min max]
% HorizontalAlignment % 'left'|'center'|'right'|'fill'
% VerticalAlignment   % 'bottom'|'middle'|'top'|'fill'

narginchk(3,3);
if ~isscalar(obj)
   error('OBJ must be a scalar UIFLOWGRIDCONTAINER object.');
end
if isempty(obj.hg)
   error('OBJ is not associated with any HG object.');
end

if isa(h,'hgwrapper')
   h = [h.hgbase];
end
if all(ishghandle(h))
   [tf,I] = ismember(handle(h),obj.elem_h);
else
   % subscripts given, get elements at the specified cells
   validateattribute(h,{'numeric'},{'2d','ncols',2,'positive','integer','finite'});
   [tf,I] = ismember(h,obj.elem_subs,'rows','stable');
end

if ~all(tf)
   error('Invalid element or cell subscripts.');
end

pnischar = ischar(pn);
if pnischar
   pn = cellstr(pn);
end

propnames = {'location','heightlimits','widthlimits','span','horizontalalignment','verticalalignment'};
pn = cellfun(@(n)validatestring(n,propnames),pn,'UniformOutput',false);
pv = cell(size(pn));

for n = 1:numel(pn)
   switch pn{n}
      case 'location'
         pv{n} = obj.elem_subs(I,:);
      case 'span'
         pv{n} = obj.elem_span(I,:);
      case 'heightlimits'
         pv{n} = obj.elem_hlims(I,:);
      case 'widthlimits'
         pv{n} = obj.elem_wlims(I,:);
      case 'horizontalalignment'
         pv{n} = obj.elem_halign_opts(obj.elem_halign(I,:));
      case 'verticalalignment'
         pv{n} = obj.elem_valign_opts(obj.elem_valign(I,:));
   end
end

if pnischar
   pv = pv{:};
end
