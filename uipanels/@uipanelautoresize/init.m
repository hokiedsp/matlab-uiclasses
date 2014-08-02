function init(obj)
%UIPANELAUTORESIZE/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@uipanelex();

obj.rfmode = hgpropmode;

obj.propopts.ResizeFcnMode = struct(...
   'StringOptions',{{'auto','manual'}});
obj.propopts.MinimumPanelSize = struct(...
   'OtherTypeValidator',{{{'numeric'},{'numel',2,'positive','finite'}}},...
   'Default',[1 1]);

obj.sortpropopts([],false,false,true,true);
