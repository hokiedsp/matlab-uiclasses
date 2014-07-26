function h = detach(obj)
%HGWRAPPER/DETACH   Detaches HG object
%   H = DETACH(OBJ) deassociates the HGWRAPPER object OBJ with its
%   associated HG object (OBJ.GraphicsHandle). The detached HG object
%   handle is returned in H. If all objects have attached HG objects, H is
%   of the same dimension as OBJ. If not, H contains a row vector of HG
%   object handles.
%
%   See also HGWRAPPER, HGWRAPPER/HGWRAPPER, HGWRAPPER/ATTACH.

if ~(any([obj.indelete]) || all(isvalid(obj)))
   error('OBJ array contains least one invalid HGWRAPPER object.');
end

if ~all([obj(:).detachable])
   error('Cannot detach at least one HG object (Object''s Detachable property is ''off'').');
end

h = cell(size(obj));
for n = 1:numel(obj)
   if ~isempty(obj(n).hg)
      h{n} = obj(n).detach_se();
   end
end

try
   h = cell2mat(h);
catch
   h = [h{:}];
end
