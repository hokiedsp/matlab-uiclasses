function getdisp(obj)
%UIAXOBJ/GETDISP   Specialized UIAXOBJ object property display.
%   GETDISP is called by GET when GET is called with no output argument 
%   and a single input parameter H an array of handles to UIAXOBJ objects.  
%
%   See also UIAXOBJ, UIAXOBJ/UIAXOBJ.

if isempty(obj), return; end

if numel(obj)>1
   error('Vector of handles not permitted for get(H) with no left hand side.');
end

obj.getdisp@hgsetgetex();

if ~isempty(obj.hg)
   props = get(obj.hg);
   pnames = fieldnames(props);
   pnames(ismember(pnames,properties(obj))) = [];
   for pname = pnames.'
      hgsetgetex.getpropdisp(pname{1},props.(pname{1}));
   end
   fprintf('\n');
end

end
