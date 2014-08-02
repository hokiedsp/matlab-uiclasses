function setSource(obj,h,pname)
%HGPROPSYNC/SETSOURCE   Set synchronization source object & property
%   SETTARGET(OBJ,H,PROPNAME) configures OBJ to monitor the HG handle
%   object in H for their properties given by PROPNAME. PROPNAME must be a
%   string containing a valid property name of H.
%
%   If OBJ is an array of HGPROPSYNC objects, H must be an array of HG
%   handles of the matching size, and PROPNAME must be a cellstr array of
%   the matching size.

narginchk(3,3);
if isempty(obj) || ~all(isvalid(obj))
   error('OBJ must be non-empty and all valid.');
end

sz = size(obj); % array size

if ~all(ishghandle(h)|isa(h,'hgsetget'))
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj.clrSource();
for n = 1:numel(obj) % for each object
   setSource_se(obj(n),h(n),pname{n});
end

end

function setSource_se(obj,h,name)

% test the property
try
   [~] = get(h,name);
catch
   error('Property "%s" does not exist for the specified %s object',name,get(h,'Type'));
end
if isempty(obj.TargetProperties) && ~isempty(obj.TargetHandles)
   set(obj.TargetHandles,cellstr(name),get(obj.TargetHandles,cellstr(name)));
end

obj.SourceHandle = h;
obj.SourceProperty = name;

% set listener for the PostSet event
obj.srclis_prop_postset = addlistener(obj.SourceHandle,obj.SourceProperty,...
   'PostSet',@(~,data)obj.prop_postsetfcn(data.NewValue));

% set listener for object destruction : clear the target 
obj.srclis_destroy = addlistener(obj.SourceHandle,'ObjectBeingDestroyed',@(~,~)obj.clrSource());

% synchronize property if targets are already set
if ~isempty(obj.TargetHandles)
   obj.prop_postsetfcn(get(obj.SourceHandle,obj.SourceProperty));
end

end
