function init(obj)
%UIPANELEX/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@hgenable();

% set public property options
obj.propopts.AutoLayout = struct(...
   'StringOptions',{{'off','on'}},...
   'Default','off');
obj.propopts.DisplayArea = struct([]);
obj.propopts.Extent = struct([]); % read-only
obj.sortpropopts([],false,false,true,true);

% initialize protected/private properties
obj.content_listeners = handle([]);

obj.autolayout = true; % enable auto-layout by default

obj.d_hgs = handle([]); % HG object monitor
obj.d_hgws = hgenable.empty; % hgwrapper object monitor

obj.d_hg_states = {}; % HG object Enable state
obj.d_hgw_states = {}; % hgwrapper object Enable state

% HG object Enable property listener
if isa(obj.d_hgs,'handle')
   obj.d_hg_listeners = handle([]);
else
   obj.d_hg_listeners = event.listener.empty;
end

% hgwrapper object Enble property monitor
obj.d_hgw_listeners = event.listener.empty; 
