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
obj.propopts.Elements = struct(...
   'OtherTypeValidator',@(val)isempty(setdiff(h,get(obj.hg,'Children'))));
obj.propopts.ElementsHeightLimits = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsWidthLimits = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsLocation = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsSpan = struct(...
   'OtherTypeValidator',@(val)validateattributes(val,{'numeric'},{'nrows',numel(obj.Elements),'ncols',2,'positive'}));
obj.propopts.ElementsHorizontalAlignment = struct(...
   'OtherTypeValidator',@(val)validateelementsalignment(val,obj.elem_halign_opts));
obj.propopts.ElementsVerticalAlignment = struct(...
   'OtherTypeValidator',@(val)validateelementsalignment(val,obj.elem_valign_opts));
obj.propopts.NumberOfElements = struct([]);
obj.sortpropopts([],false,false,true,true);

end

function val = validateelementsalignment(val,opts)
validateattributes(val,{'cell'},{'numel',numel(obj.elem_h)});
val = cellfun(@(v)validatestring(v,opts),val,'UniformOutput',false);
[~,val] = ismember(val,opts);
val = val - 1;
end
