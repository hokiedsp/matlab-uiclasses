function init(obj)
%UIAXESARRAY/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@uiflowgridcontainer();

obj.inclabel = false;
obj.xlink_listeners = handle([]);
obj.ylink_listeners = handle([]);

obj.propopts.AutoLayout.Default = 'on';
obj.propopts.Margins.Default = [0 0 0 0];
obj.propopts.ElementSpacings.Default = [0 0];

obj.propopts.IncludeLabels = struct(...
   'StringOptions',{{'on','off'}},...
   'Default','on');
obj.propopts.XLimLinkedColumns = struct(...
   'OtherTypeValidator',@(val)validatelinks(obj,val,2));
obj.propopts.YLimLinkedRows = struct(...
   'OtherTypeValidator',@(val)validatelinks(obj,val,1));

obj.sortpropopts([],false,false,true,true);

end

function validatelinks(obj,val,idx)

validateattributes(val,{'numeric'},{'integer','positive','<=',obj.gridsize(idx)});

end
