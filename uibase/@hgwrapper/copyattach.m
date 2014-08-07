function copyattach(obj,src,varargin) 
%HGWRAPPER/COPYATTACH   Attach a copy of specified graphics object
%   COPYATTACH(OBJ,H) makes a copy of the HG objects specified by the
%   handles in the vector H, then attachs the copied objects to the
%   HGWRAPPER object OBJ. If OBJ is an array of HGWRAPPER objects, the
%   H can be a scalar handle or an array of handles with matching size.
%
%   COPYATTACH(OBJ,SRCOBJ) makes a copy of the HG objects that are attached
%   to the source HGWRAPPER object, SRCOBJ, then attachs the copied HG
%   objects to OBJ. OBJ and SRCOBJ must be the same HGWRAPPER-derived
%   class. If they are heterogeneous arrays, the classes of objects must
%   match in an element-by-element sense. If SRCOBJ is detached, the
%   corresponding OBJ also detaches its attached HG object.
%
%   ATTACH(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value...) sets the
%   properties of both OBJ (and its attached object) after the new HG
%   object is attached. If any elements of SRCOBJ don't have attached HG
%   objects, these properties will not be set for the corresponding OBJ
%   elements.
%
%   See also HGWRAPPER/ATTACH, HGWRAPPER, HGWRAPPER/HGWRAPPER,
%   HGWRAPPER/DETACH.

narginchk(2,inf)
N = numel(obj);
inc_src = ~isscalar(src);

if inc_src && isequal(size(src),size(obj))
   error('Size of source object array must match that of OBJ.');
end

if isa(src,'hgwrapper')
   srcNoHG = true(N,1);
   m = 1;
   for n = 1:N
      if ~strcmp(class(obj(n)),class(src(m)));
         error('Source HGWRAPPER class must match OBJ class in the element-by-element fashion.');
      end
      srcNoHG(n) = ~src(m).isattached();
      m = m + inc_src;
   end
   
   % detach HG objects from OBJ which corresponding SRCOBJ is not attached
   obj(srcNoHG).detach();
   obj(srcNoHG) = []; % remove detached OBJ from consideration
   if inc_src
      src(srcNoHG) = []; % 
   elseif srcNoHG(1) % if 
      src = [];
   end
   
   if isempty(src) % none attached, exit
      return;
   end
   
   % get the source HG objects
   src = [src.hg];
   
elseif ~all(ishghandle(src))
   error('All elements of H must be valid HG handles.');
end

p = cell2mat(get(src,{'Parent'}));
if ~inc_src
   p = repmat(p,size(obj));
end
h = copyobj(src,p);
try
   obj.attach(h,varargin{:});
catch ME
   delete(h)
   ME.rethrow();
end
