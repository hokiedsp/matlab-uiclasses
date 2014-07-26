function validatehg(obj,h)
%UIPANELGROUP/VALIDATEHG   Check for HG object compatibility
%   VALIDATEHG(OBJ,H) is called by HGWRAPPER/ATTACH() to make sure that the
%   HG object H is compatible with OBJ. VALIDATEHG errors out if H is not
%   supported by OBJ.

%For UIPANELGROUP, if the panel object to be attached must only have panels
%as its children

obj.validatehg@uipanelex(h);

for n = 1:numel(h)
   
   hc = get(get(h(n),'Children'));
   try
      for k = 1:numel(hc)
         % try to add a dummy event listener
         lis = addlistener(hc,'ObjectChildAdded',@(~,~)disp(''));
         delete(lis);
      end
   catch
      error('Cannot attach this uiflowcontainer HG object. Its existing Children must have ''Children'' properties and have ObjectChildAdded event.');
   end
end
