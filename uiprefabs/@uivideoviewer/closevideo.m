function closevideo(obj)
%UIVIDEOVIEWER/CLOSEVIDEO   Close currently shown video
%   CLOSEVIDEO(OBJ)

% stops the timer if running
obj.stop();

% clear vr
if obj.autounload
   delete(obj.vr);
end
obj.vr = [];

% show the axes
set(obj.hg,'Visible','on','DataAspectRatioMode','auto');

% hide image & frame # text
set(obj.im,'Visible','off');
set(obj.tx,'Visible','off');
