function init(obj)
%UIPANELGROUP/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

% run superclass init first
obj.init@uipanelex();

% New properties
obj.propopts.Panels = struct(...
   'OtherTypeValidator',@(val)all(uipanelgroup.ispanel(val)));
obj.propopts.PanelPositions = struct(...
   'OtherTypeValidator',{{{'numeric'},{'nrows',numel(obj.Panels),'ncols',4,'finite'}}});
obj.propopts.PanelUnits = struct(...
   'StringOptions',{{'inches','centimeters','normalized','points','pixels','characters'}});

obj.propopts.NumberOfPanels = struct(...
   'OtherTypeDesc',{{'positive integer'}},...
   'OtherTypeValidator',{{{'numeric'},{'scalar','nonnegative','finite','integer'}}});
obj.propopts.DefaultPanelType = struct(...
   'StringOptions',{{'uicontainer','uipanel'}},...
   'OtherTypeDesc',{{'function_handle'}},...
   'OtherTypeValidator',@(val)isa(val,'function_handle'),...
   'Default','uicontainer');

obj.sortpropopts([],false,false,true,true);
