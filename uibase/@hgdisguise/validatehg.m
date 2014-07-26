function validatehg(obj,h)
%HGDISGUISE/VALIDATEHG   Check for HG object compatibility
%   VALIDATEHG(OBJ,H) is called by HGWRAPPER/ATTACH() to make sure that the
%   HG objects in H are compatible with OBJ. VALIDATEHG errors out if H is
%   not supported by OBJ.
%
%   HGDISGUISE uses completely new VALIDATEHG (without calling any of
%   superclass VALIDATEHG) since HGDISGUISE OBJ internally creates a
%   uicontainer and attaches to it and moves H under the new uicontainer.

if ~all(ishghandle(h(:)))
   error('hgdisguise:NotHG','H is not a valid HG handle.');
end
if ~isequal(size(h),size(obj))
   error('hgdisguise:UnmatchedSize','Size of H must match that of OBJ.');
end

% if specific types of HG object is supported by the subclass, check
supportedtypes = obj.supportedtypes();
if ~isempty(supportedtypes)
   
   % before R2014b, uibuttongroup is reported as 'uipanel'
   check_uibg = verLessThan('matlab', '8.4.0') && any(strcmp(supportedtypes,'uibuttongroup'));
   
   types = get(h,{'type'});
   for n = 1:numel(h)
      if ~any(strcmp(types{n},supportedtypes)) && ...
            (check_uibg && isempty(findobj(h,'flat','Type','uipanel','-property','SelectedObject')))
         error('hgdisguise:UnsupportedHG','Unsupported HG type.');
      end
   end
end

% Does not support axes objects
p = ancestor(get(h,'Parent'),'axes');
if ~iscell(p) % multiple h
   p = {p};
end
if ~all(cellfun(@(p)isempty(p),p))
   error('hgdisguise:UnsupportedHG','H cannot be an axes object.');
end
