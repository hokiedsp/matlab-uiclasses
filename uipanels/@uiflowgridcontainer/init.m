function init(obj)
%UIFLOWGRIDCONTAINEREX/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@uipanelautoresize();

obj.elem_h = handle([]);       % HG objects on the grid
obj.elem_wlims = zeros(0,2);   % elements' width limits
obj.elem_hlims = zeros(0,2);   % elements' height limits
obj.elem_subs = zeros(0,2);    % elements' placement subcripts
obj.elem_span = zeros(0,2);    % elements' sizes in cells
obj.elem_halign = zeros(0,1);  % elements' horizontal alignment w/in cell
obj.elem_valign = zeros(0,1);  % elements' vertical alignment w/in cell
obj.elem_hfixed = false(0,1);
obj.elem_vfixed = false(0,1);

obj.elem_halign_opts = {'left','center','right'}.';  % supported option strings
obj.elem_valign_opts = {'bottom','middle','top'}.'; % supported option strings

obj.defer = false; % by default, layout immediately
obj.propopts.AutoExpand = struct(...
   'StringOptions',{{'on','off'}},...
   'Default','on');
obj.propopts.ExcludedChildren = struct(...
   'OtherTypeValidator',@(val)isempty(setdiff(h,get(obj.hg,'Children'))));
obj.propopts.GridSize = struct(...
   'OtherTypeValidator',@(val)obj.validategridsize(val),...
   'Default',[1 1]);
obj.propopts.GridFillingOrder = struct(...
   'StringOptions',{{'columnsfirst','rowsfirst'}},...
   'Default','rowsfirst');
obj.propopts.HorizontalAlignment = struct(...
   'StringOptions',{{'left','center','right'}},...
   'Default','left');
obj.propopts.ElementSpacings = struct(...
   'OtherTypeValidator',{{{'numeric'},{'numel',2,'nonnegative','finite'}}},...
   'Default',[10 10]);
obj.propopts.Margins = struct(...
   'OtherTypeValidator',{{{'numeric'},{'numel',4,'nonnegative','finite'}}},...
   'Default',[10 10 10 10]);
obj.propopts.VerticalAlignment = struct(...
   'StringOptions',{{'bottom','middle','top'}},...
   'Default','top');
obj.propopts.EliminateEmptySpace = struct(...
   'StringOptions',{{'on','off'}},...
   'Default','off');
obj.propopts.HorizontalWeight = struct(...
   'OtherTypeValidator',@(val)validate_weight(val,'HorizontalWeight'));
obj.propopts.VerticalWeight = struct(...
   'OtherTypeValidator',@(val)validate_weight(val,'VerticalWeight'));

obj.propopts.Elements = struct(...
   'OtherTypeValidator',@(val)isempty(setdiff(val,get(obj.hg,'Children'))));
obj.propopts.ElementsHeightLimits = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsWidthLimits = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsLocation = struct(...
   'OtherTypeValidator',@(val)validate_elemsubs(obj,val));
obj.propopts.ElementsSpan = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsHorizontalAlignment = struct(...
   'OtherTypeValidator',@(val)validateelementsalignment(obj,val,obj.elem_halign_opts));
obj.propopts.ElementsVerticalAlignment = struct(...
   'OtherTypeValidator',@(val)validateelementsalignment(obj,val,obj.elem_valign_opts));
obj.propopts.NumberOfElements = struct([]);

obj.propopts.ElementsHeightFixed = struct(...
   'OtherTypeValidator',@(val)validateelementsalignment(obj,val,{'on','off'}));
obj.propopts.ElementsWidthFixed = struct(...
   'OtherTypeValidator',@(val)validateelementsalignment(obj,val,{'on','off'}));

obj.propopts.ElementsFlowing = struct(...
   'StringOptions',{{'on','off'}},...
   'Default','off');

obj.sortpropopts([],false,false,true,true);

end

function validateelementsalignment(obj,val,opts)
validateattributes(val,{'cell'},{'numel',numel(obj.elem_h)});
cellfun(@(v)validatestring(v,opts),val,'UniformOutput',false);
end

function validate_weight(val,name)
validateattributes(val,{'numeric'},{'positive'},'set',name);
if any(isinf(val))
   error('%s values must be finite or NaN.');
end
end

function validate_elemsubs(obj,val)
validateattributes(val,{'numeric'},{'ncols',2,'nrows',numel(obj.Elements),'positive','integer','positive'});
if val(:,1)>obj.gridsize(1)
   error('At least one row index exceeds OBJ.GridSize(1).');
end
if val(:,2)>obj.gridsize(2)
   error('At least one column index exceeds OBJ.GridSize(2).');
end

if size(unique(val,'rows'),1)~=size(val,1)
   error('Rows of OBJ.ElementsLocation must be unique.');
end

end
