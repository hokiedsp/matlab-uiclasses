function setTarget(obj,h,pname)
%HGPROPSYNC/SETTARGET   Set target objects and properties
%   SETTARGET(OBJ,H) configures OBJ to set their HG handle objects in H as
%   the target. The target property is the same property as the source. If
%   OBJ is an array, H must also be an array of the same size.
%
%   SETTARGET(OBJ,H,PROPNAME) configures a scalar OBJ to set the HG handle
%   objects in H and their properties given by the string in PROPNAME as
%   the synchronization target. If H is an HG handle array, PROPNAME must
%   be a cellstr array of the matching size.
%
%   If OBJ is an array of HGPROPSYNC objects, SETTARGET sets only a single
%   target for each OBJ element. H and PROPNAME must be arrays of the same
%   size as OBJ.

narginchk(2,3);
if isempty(obj) || ~all(isvalid(obj))
   error('OBJ must be non-empty and all valid.');
end

if ~(all(ishghandle(h))||all(isa(h,'hgsetget')))
   error('H must be an array of valid HG handles or an array of valid HGSETGET objects.')
end

pnempty = nargin<3 || isempty(pname);
if ~pnempty
   if ischar(pname) && isrow(pname)
      pname = cellstr(pname);
   elseif ~iscellstr(pname)
      error('PROPNAME must be a string or cellstr array.');
   end
end

if pnempty % 'propertynames' not given
   if ~(isscalar(obj)||isequal(size(h),size(obj)))
      error('The array size of H does not match that of OBJ.');
   end
   obj.clrTarget();
   if isscalar(obj)
      setTarget_se(obj,h);
   else
      for n = 1:numel(obj)
         setTarget_se(obj(n),h(n));
      end
   end
elseif isscalar(obj) % H and PROPNAME must be scalar or matching size
   if ~(isscalar(h) || isscalar(pname) || size(pname)==size(h))
      error('PROPNAME size must match that of H or either H or PROPNAME must be a scalar.');
   end
   
   obj.clrTarget();
   setTarget_se(obj,h,pname);
   
else % array OBJ, H and PROPNAME must be scalar or of the same dimension
   sz = size(obj); % array size
   hisscalar = isscalar(h);
   pisscalar = isscalar(pname);
   if ~(hisscalar || isequal(size(h),sz))
      error('The array size of H does not match that of OBJ.');
   end
   if ~(pisscalar || isequal(size(pname),sz))
      error('Property names must be given in a cellstr with its array size matching that of OBJ.');
   end
   if hisscalar && pisscalar
      error('If OBJ is an array of HGPROPSYNC, both H and PROPNAME cannot be both scalars.');
   end
   
   obj.clrTarget();
   arg = {h(1)};
   arg{2} = pname(1);
   for n = 1:numel(obj) % # of objects
      if ~hisscalar
         arg{1} = h(n);
      end
      if ~pisscalar
         arg{2} = pname{n};
      end
      setTarget_se(obj(n),arg{:});
   end
   
end

end

function setTarget_se(obj,h,pname)

obj.TargetHandles = h;
if nargin<3
   % make sure the property
   set(h,obj.SourceProperty,get(h,obj.SourceProperty));
   obj.TargetProperties = '';
else
   % make sure the property
   set(h,cellstr(pname),get(h,cellstr(pname)));
   
   if isscalar(pname)
      obj.TargetProperties = char(pname);
   else
      obj.TargetProperties = pname;
   end
end

% set listener for object destruction : clear the target
for n = 1:numel(h)
   obj.dstlis_destroy(n) = addlistener(h(n),'ObjectBeingDestroyed',@(~,~)obj.clrTarget());
end

% synchronize property if source is already set
if ~isempty(obj.SourceHandle)
   obj.prop_postsetfcn(get(obj.SourceHandle,obj.SourceProperty));
end

end
