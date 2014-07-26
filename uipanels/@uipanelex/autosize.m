function autosize(obj) 
%UIPANELEX/AUTOSIZE   Adjust base HG Position to match the content extent
%   AUTOSIZE(OBJ)

for n = 1:numel(obj)
   if ~obj.isattached(), continue; end
   obj(n).autosize_se();
end
