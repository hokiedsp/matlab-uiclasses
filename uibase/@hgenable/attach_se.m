function attach_se(obj,h)
%HGENABLE/ATTACH_SE   Attaches an HG object
%   ATTACH(OBJ,H) associates the HG object, specified by its handle given
%   in H, with the HGENABLE object OBJ. If OBJ is an array of HGENABLE
%   objects, the number of elements in OBJ and H must agree.
%
%   If OBJ.AutoDetach = 'off' (default) deleting OBJ or H also deletes the
%   other as well. Set OBJ.AutoDetach = 'on' to avoid this behavior.
%
%   See also HGENABLE, HGENABLE/HGENABLE, HGENABLE/DETACH.

% continue on with standard attach procedure
obj.attach_se@hgwrapper(h);

obj.natively_supported = false;
if obj.isattached()
   % Check for attached object's Enable support
   try
      get(h,'Enable')
      obj.natively_supported = true;
   catch
   end
end
