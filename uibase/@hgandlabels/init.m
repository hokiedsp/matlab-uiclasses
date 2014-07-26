function init(obj)
%HGANDLABELS/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@hgdisguise();

obj.labels_h = handle([]);
obj.labels_htext = {};    % text handle for tex/latex text interpreter support
obj.labels_layout = zeros(0,3);

obj.propopts.HgHeightLimits = struct(...
   'OtherTypeValidator',{{{'numeric'},{'numel',2,'positive','nondecreasing'}}},...
   'Default',[2 inf]);
obj.propopts.HgWidthLimits = struct(...
   'OtherTypeValidator',{{{'numeric'},{'numel',2,'positive','nondecreasing'}}},...
   'Default',[2 inf]);

obj.propopts.LabelHandles = struct([]);   % Label uicontrol handles
obj.propopts.LabelStrings  = struct([]);
obj.propopts.LabelMargins = struct(...
   'OtherTypeValidator',{{{'numeric'},{'scalar','nonnegative','finite'}}});
obj.propopts.LabelLocations = struct(...
   'StringOptions',{{'west','east','south','north'}});
obj.propopts.LabelHorizontalAlignments = struct(...
   'StringOptions',{{'left','center','right'}});
obj.propopts.LabelVerticalAlignments = struct(...
   'StringOptions',{{'bottom','middle','top'}});
obj.propopts.LabelInterpreters = struct(...
   'StringOptions',{{'none','latex','tex'}});

obj.sortpropopts([],false,false,true,true);
