function setElement(obj,varargin)
%UIFLOWGRIDCONTAINER/SETELEMENT
%   SETELEMENT(OBJ,H,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
%   SETELEMENT(OBJ,SUBS,...)
%   SETELEMENT(...,pv,pn)
%
% Location     % [row column] element's location on the grid ([1 1] is at the upper-left-corner).
% Span         % How many grid cells to occupy: each row [nrows ncols]
% HeightLimits % height limits in pixels, each row: [min max]
% WidthLimits  % width limits in pixels, each row: [min max]
% HorizontalAlignment % 'left'|'center'|'right'|'fill'
% VerticalAlignment   % 'bottom'|'middle'|'top'|'fill'

narginchk(4,inf);
if ~isscalar(obj)
   error('OBJ must be a scalar %s object.',class(obj));
end
if isempty(obj.hg)
   error('OBJ is not associated with any HG object.');
end

h = varargin{1};
N = numel(h);
if isa(h,'hgwrapper')
   hg = [h.hgbase];
   if numel(hg)~=N
      error('All HGWRAPPER must be attached to HG objects.');
   end
else
   hg = h;
end
if all(ishghandle(hg))
   [tf,I] = ismember(handle(hg),obj.elem_h);
else
   % subscripts given, get elements at the specified cells
   validateattributes(hg,{'numeric'},{'2d','ncols',2,'positive','integer','finite'});
   [tf,I] = ismember(hg,obj.elem_subs,'rows');
   h = obj.elem_h(I);
end

if ~all(tf)
   error('Invalid element or cell subscripts.');
end

if mod(nargin,2)~=0
   error('Invalid property name-value pair.');
end

if nargin==4 && all(cellfun(@iscell,varargin([2 3])))
   pn = varargin{2};
   pv = varargin{3};
else
   pn = varargin(2:2:end);
   pv = varargin(3:2:end);
   if all(cellfun(@(val)iscell(val)&&iscolumn(val),pv))
      pv = [pv{:}];
   end
end

propnames = {'location','heightlimits','widthlimits','span','horizontalalignment','verticalalignment'};
isgridprop = true(size(pn));
for n = 1:numel(pn)
   try
      pn{n} = validatestring(pn{n},propnames);
   catch
      isgridprop(n) = false;
   end
end

alprev = obj.autolayout;
obj.autolayout = false;

% extract the location and span properties
ploc = strcmp(pn,'location');
pspan = strcmp(pn,'span');
if any(ploc)
   loc = cell2mat(pv(:,find(ploc,1,'last'))); % only consider the last value
else
   loc = [];
end
if any(pspan)
   span = cell2mat(pv(:,find(pspan,1,'last'))); % only consider the last value
else
   span = [];
end
pn(ploc|pspan) = [];
pv(ploc|pspan) = [];
isgridprop(ploc|pspan) = [];

gridupdate = ~(isempty(loc)&&isempty(span));
if gridupdate
   set_grid(obj,I,loc,span);
end

for n = 1:numel(pn)
   if isgridprop(n)
      switch pn{n}
         case 'heightlimits'
            set_lims(obj,I,pv(:,n),4,'elem_hlims');
         case 'widthlimits'
            set_lims(obj,I,pv(:,n),3,'elem_wlims');
         case 'horizontalalignment'
            set_align(obj,I,pv(:,n),obj.elem_halign_opts,'elem_halign');
         case 'verticalalignment'
            set_align(obj,I,pv(:,n),obj.elem_valign_opts,'elem_valign');
      end
   else % element property
      set(h,pn(n),pv(:,n));
   end
end

% revert the auto-layout mode
obj.autolayout = alprev;

% perform necessary layout update
if gridupdate
   obj.update_grid(); % re-map the grid elements
else
   obj.layout_panel(); % just re-layout
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_grid(obj,IND,subs,span)

N = numel(IND);
if isempty(subs)
   subs = obj.elem_subs(IND,:);
else
   if numel(subs)==2
      subs = repmat(subs(:).',N,1);
   end
   validateattributes(subs,{'numeric'},{'2d','nrows',N,'ncols',2,'positive','integer'});
end

if isempty(span)
   span = obj.elem_span(IND,:);
else
   if isscalar(span)
      span = repmat(span,size(subs));
   elseif numel(span)==2
      span = repmat(span(:).',N,1);
   end
   validateattributes(span,{'numeric'},{'2d','nrows',N,'ncols',2,'positive','integer'});
end

% check cell mapping to avoid overlapping
gsz = obj.gridsize;
map = obj.map;
map(ismember(map(:),IND)) = 0; % clear elements being remapped
for n = 1:N
   I = subs(n,1):(subs(n,1)+span(n,1)-1);
   J = subs(n,2):(subs(n,2)+span(n,2)-1);
   if I(end)>gsz(1) || J(end)>gsz(2)
      error('New element Location & Spanning exceeds the grid.');
   end
   loc = map(I,J);
   if any(loc(:)~=0)
      error('New element Location & Spanning creates element overlapping.');
   end
   
   % mark the cells that it now occupies
   map(I,J) = IND(n);
end

% all good
obj.elem_subs(IND,:) = subs;
obj.elem_span(IND,:) = span;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_lims(obj,I,val,posidx,pname)

N = numel(I);
val = cell2mat(val);
if size(val,1)==1
   val = repmat(val,N,1);
end
validateattributes(val,{'numeric'},{'2d','nrows',N,'ncols',2});

% check for tight fit request
set(obj.content_listeners,'Enabled','off');
for n = 1:numel(I)
   tf = val(n,:)<=0;
   if any(tf)
      h = obj.elem_h(I(n));
      u = get(h,'Units');
      set(h,'Units','pixels');
      pos = get(h,'Position');
      set(h,'Units',u);
      val(n,tf) = pos(posidx);
   end
end
set(obj.content_listeners,'Enabled','on');

obj.(pname)(I,:) = val;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set halign
function set_align(obj,I,val,opts,pname)

val = cell2mat(val);
if ischar(val) && isrow(val)
   val = cellstr(val);
end
N = numel(I);
if isscalar(val)
   val = repmat(val,N,1);
end

validateattributes(val,{'cell'},{'numel',N});
val = cellfun(@(v)validatestring(v,opts),val,'UniformOutput',false);
[~,val] = ismember(val,opts);
obj.(pname)(I) = val;

end
