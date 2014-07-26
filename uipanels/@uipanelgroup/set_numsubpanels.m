function set_numsubpanels(obj,Nc)
%UIPANELGROUP/SET_NUMSUBPANELS   Change # of panels
%   SET_NUMSUBPANELS(OBJ,Nc) configures to house Nc subpanels. If current #
%   of subpanels does not match Nc, subpanels will be either added or
%   removed.
%
% currently registered panels
% hpanels = obj.content_listeners.getsources();
hlistened = get(obj.content_listeners,{'Container'});
hlistened = [hlistened{:}];
hpanels = unique(hlistened);
npanels = numel(hpanels);

delta = Nc-npanels;
if delta==0, return; end % no change

added = delta>0;
if added
   for n = delta:-1:1
      obj.default_type('Parent',obj.hg);
   end
else % removed
   delete(hpanels(end+delta+1:end));
end
