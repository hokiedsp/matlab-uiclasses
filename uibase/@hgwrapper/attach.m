function attach(obj,h,varargin)
%HGWRAPPER/ATTACH   Attaches a panel-type HG object
%   ATTACH(OBJ,H) associates the HG object, specified by its handle given
%   in H, with the HGWRAPPER object OBJ. If OBJ is an array of HGWRAPPER
%   objects, the number of elements in OBJ and H must agree.
%
%   If OBJ.AutoDetach = 'off' (default) deleting OBJ or H also deletes the
%   other as well. Set OBJ.AutoDetach = 'on' to avoid this behavior.
%
%   ATTACH(OBJ,H,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value...) sets
%   the properties of both OBJ and H.
%
%   See also HGWRAPPER, HGWRAPPER/HGWRAPPER, HGWRAPPER/DETACH.

% For all derived classes, call this attach function before adding any
% other listeners to hg_listener array

if ~isequal(size(obj),size(h))
   error('OBJ array and H array must be of the same size.');
end

if ~all(isvalid(obj))
   error('OBJ array contains least one invalid HGWRAPPER object.');
end

if ~all([obj(:).attachable])
   error('Cannot attach HG objects. OBJ array contains unattachable HGWRAPPER object.');
end

hasH = ~isempty(h); % -> detach

if hasH
   % check arguments
   if ~all(obj.isvalid)
      error('OBJ is not valid.');
   end
   if ~all([obj(:).detachable])
      error('All OBJ elements must be detachable objects.');
   end
   obj.validatehg(h);
end

% detach first
obj.detach();

if hasH
   for n = 1:numel(obj)
      attach_se(obj(n),h(n));
   end
end

% set properties if given
if ~isempty(varargin)
   set(obj,varargin{:});
end
