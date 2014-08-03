function init(obj)
%FIGCTRL_MOUSEOVER/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.wbmf_mode = hgpropmode;
obj.killfcn = @(~,event)kill_listener(obj,event); % possibly SourceObject as well
obj.hit = 0;       % used in mousemoved()
obj.ptrstyle = {}; % default pointer style

obj.h = handle([]);% associated HG handles
obj.cbfcns = {};   % mousemovedaction callback functions
obj.el = handle([]);

obj.propopts.WindowButtonMotionFcnMode = struct(...
   'StringOptions',{{'auto','manual'}});

end

function kill_listener(obj,event)
% must try different handle.event field possibilities

try
   obj.kill_monitor(event.SourceObject)
catch
   obj.kill_monitor(event.Source)
end

end
