function setTarget(obj,h,pname,defval,setnow)
%HGPROPMODE/SETTARGET   Set target property
%   SETTARGET(OBJ,H,PROPNAME,DEFAULTVALUE) configures OBJ to monitor the HG
%   handle objects in H for their properties given by PROPNAME. H must be
%   HG handle array of matching size as OBJ. If OBJ is scalar, PROPNAME
%   must be a string. If H is non-scalar, PROPNAME may be a string for a
%   common property name or a cellstr array of matching size. The default
%   value for the property is given in the DEFAULT argument. Like PROPNAME,
%   DEFAULT maybe a non-cell object to set a common value or a cell array
%   of matching size as H.
%
%   SETTARGET(OBJ,H,PROPNAME,DEFAULTVALUE,SETNOW) gives an option to set
%   the property value to the default value. By default, SETNOW=true and
%   the property value is set to its default value in SETTARGET. Specifying
%   SETNOW=false leaves the current property value unchanged but
%   OBJ.HASVALUECHANGED() method returns true until
%   OBJ.SETPROPERTYTODEFAULT() method is called.

narginchk(4,5);
if isempty(obj) || ~all(isvalid(obj))
   error('OBJ must be non-empty and all valid.');
end

sz = size(obj); % array size

if ~all(ishghandle(h))
   error('H must be valid HG handles.')
end
if ~isequal(size(h),sz)
   error('The array size of H does not match that of OBJ.');
end

if ischar(pname) && isrow(pname)
   pname = repmat({pname},sz);
elseif ~(iscellstr(pname) && isequal(size(pname),sz))
   error('Property names must be given in a cellstr with its array size matching that of OBJ.');
end

if ~iscell(defval)
   defval = repmat({defval},sz);
elseif ~(iscell(defval) && isequal(size(defval),sz))
   error('The size of the cell array of default values must match that of OBJ.');
end

if nargin<5
   setnow = true;
else
   validateattributes(setnow,{'logical'},{'scalar'});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj.clrTarget();
for n = 1:numel(obj) % # of objects
   setTarget_se(obj(n),h(n),pname{n},defval{n});
end

if setnow
   obj.setPropertyToDefault();
else
   [obj.valchg] = deal(true); % value is not default (thus "changed") until setPropertyToDefault is called
end

end

function setTarget_se(obj,varargin)

[obj.GraphicsHandle, obj.PropertyName, obj.DefaultValue] = deal(varargin{:});

% set listener for the PostSet event
obj.lis_prop_postset = addlistener(obj.GraphicsHandle,obj.PropertyName,...
   'PostSet',@(~,~)obj.prop_postsetfcn());

% set listener for object destruction : clear the target 
obj.lis_destroy = addlistener(obj.GraphicsHandle,'ObjectBeingDestroyed',@(~,~)obj.clrTarget());

end
