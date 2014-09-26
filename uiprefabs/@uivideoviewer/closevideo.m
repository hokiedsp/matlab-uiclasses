function closevideo(obj)
%UIVIDEOVIEWER/CLOSEVIDEO   Close currently shown video
%   CLOSEVIDEO(OBJ)

% save the current visibility
vis = obj.get_visible();

% stops the timer if running
obj.stop();

% clear vr
if obj.autounload
   delete(obj.vr);
end
obj.vr = [];

% show the axes
set(obj.hg,'DataAspectRatioMode','auto');

% set visibility
obj.set_visible(vis(2)=='n'); % calls set_visible to set visibility of im and others
