function h = hgbase(obj)
%HGWRAPPER/HGBASE   Get lowest-level HG class
%   H = HGBASE(OBJ) returns an array H of HG objects 

if ~all(obj.isattached())
   error('All HGWRAPPER objects in OBJ must be attached to HG objects.');
end

h = repmat(handle(-1),size(obj));

for n = 1:numel(obj)
   h(n) = obj(n).hgbase_se();
end

try
   h = double(h);
catch
end
