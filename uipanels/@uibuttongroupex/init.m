function init(obj)
%UIBUTTONGROUPEX/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@uiflowgridcontainer();

% initialize element handle vector as a vector of handles
obj.elem_h = handle([]);

obj.propopts.ElementsNames = struct(...              % 2d cellstr array (empty to skip a grid cell)
   'OtherTypeValidator',@(val)(iscellstr(val)&&ismatrix(val)));
obj.propopts.DefaultElementStyle = struct(...
   'StringOptions',{{'radiobutton','togglebutton'}},...
   'Default','radiobutton');
obj.propopts.SelectedIndex = struct(...
   'OtherTypeValidator',@(val)obj.validate_selected(val));
obj.propopts.SelectedName = struct(...
   'OtherTypeValidator',@(val)obj.validate_selected(val));

obj.sortpropopts([],false,false,true,true);

% initialize protected/private properties
