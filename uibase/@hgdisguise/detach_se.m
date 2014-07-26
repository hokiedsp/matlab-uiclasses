function h = detach_se(obj)
%HGDISGUISE/DETACH_SE   Detaches HG object from scalar HGWRAPPER object
%   H = DETACH_SE(OBJ) deassociates the HGANDLABELS object OBJ with its
%   associated HG object (OBJ.GraphicsHandle). The OBJ is guaranteed to be
%   scalar and OBJ.hg is also guaranteed to be occupied.

% detach the hpanel to OBJ
h = obj.hg;
hpanel = obj.detach_se@uipanelex();
if isempty(hpanel) || ~ishghandle(hpanel)
   h = [];
   return;
end

if obj.removepanel
   % retrieve the wrapped HG object
   h = get(hpanel,{'Children'});
   h = [h{:}];
   
   % if parent object is not being deleted, move the object back to the
   % panel's Parent at where the panel is
   p = get(hpanel,'Parent');
   if strcmp(get(p,'BeingDeleted'),'off')
      set(h,{'Parent','Units','Position'},get(hpanel,{'Parent','Units','Position'}));
   end
   
   % delete tha panel
   delete(hpanel);
end
