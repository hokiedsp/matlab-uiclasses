function h = getsources(obj)
%HGLISTENER_MANAGER/GETSOURCE
%   H = GETSOURCE(OBJ) returns all HG objects whose events are being listened

if isempty(obj.Listeners)
   hc = {handle([])};
else
   if isa(obj.Listeners,'handle.listener')
      hc = get(obj.Listeners,{'Object'}); % event.listener
   else %isa(obj.Listeners,'event.listener')
      hc = get(obj.Listeners,{'Container'}); % handle.listener
   end
end

h = [hc{:}];

try
   h = double(h);
catch
end

h = unique(h);
