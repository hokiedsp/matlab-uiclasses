function init(obj)
%HGDISGUISE/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@uipanelautoresize();

obj.p_listener = handle([]);
obj.create_panel_fcn = @uicontainer;

obj.propopts.PanelHandle = struct([]);    % Enclosing uicontainer handle
obj.propopts.Position = struct(...
   'OtherTypeValidator',{{{'numeric'},{'vector','numel',4,'finite'}}});
obj.propopts.Units = struct(...
   'StringOptions',{{}});
obj.propopts.DetachAsIs = struct(...
   'StringOptions',{{'off','on'}},...
   'Default','off');

obj.propopts.AutoLayout.Default = 'on';

obj.sortpropopts([],false,false,true,true);
