function validatehg(obj,h)
%HGWRAPPER/VALIDATEHG   Check for HG object compatibility
%   VALIDATEHG(OBJ,H) is called by HGWRAPPER/ATTACH() to make sure that the
%   HG object H is compatible with OBJ. VALIDATEHG errors out if H is not
%   supported by OBJ.

if ~all(ishghandle(h(:)))
   error('hgwarpper:NotHG','H is not a valid HG handle.');
end
if ~isequal(size(h),size(obj))
   error('hgwrapper:UnmatchedSize','Size of H must match that of OBJ.');
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
         error('hgwrapper:UnsupportedHG','Unsupported HG type.');
      end
   end
end

% Place the duplicate HGWRAPPER check at the end as some derived object may
% shuffle its HG objects during attach (see HGLABELED)
if ~isempty(hgwrapper.instance_manager('find',h))
   error('hgwrapper:AlreadyWrapped','HG object has already been associated with another HGWRAPPER object.');
end
