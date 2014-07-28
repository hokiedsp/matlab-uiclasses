function init(obj)
%HGWRAPPERLINK/PROPOPTS   Returns set/get property attribute cell

obj.links = hgwrapper.empty; % empty object of the same type
obj.link_master = []; % true if it leads the change among linked uicursors
obj.propopts.LinkedObjects = struct(...
   'OtherTypeValidator',@(val)isempty(val)||isa(val,class(obj)));

obj.sortpropopts([],false,true,true,true);
