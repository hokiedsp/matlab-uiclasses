function monitor_bgcolor(obj,p)
%HGDISGUISE/MONITOR_BGCOLOR   Set up parent's background color monitoring
%   MONITOR_BGCOLOR(OBJ,P) sets OBJ.hpanel's background color and start
%   monitoring for the parent's background color change

% determine which color property of the parent object specifies the
% background color.
try
   pname = 'BackgroundColor'; % uipanel, uicontainer
   get(p,pname);
catch
   pname = 'Color'; % figure
   get(p,pname);
end

obj.match_bgcolor(p,pname);

if ~isempty(obj.p_listener), delete(obj.p_listener); end
try
   obj.p_listener = addlistener(p,pname,'PostSet',@(~,~)obj.match_bgcolor(p,pname));
catch
   obj.p_listener = handle([]);
end
