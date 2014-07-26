function setdisp(obj)
%HGWRAPPER/SETDISP   Specialized HGWRAPPER object property set display.
%   SETDISP is called by SET when SET is called with no output argument
%   and a single input parameter OBJ is a scalar HGWRAPPER object.
%
%   See also HGWRAPPER, HGWRAPPER/HGWRAPPER.

% Assume that the validity of the OBJ has been confirmed

% list explicitly specified properties in setopts

obj.setdisp@hgsetgetex();

if ~isempty(obj.hg)
   
   %set(obj.hg)
   
   props = set(obj.hg);
   pnames = fieldnames(props);
   
   % eliminate the overlapped property names from HG
   pnames(ismember(pnames,properties(obj))) = [];
   
   for pname = pnames.'
      hgwrapper.setpropdisp(pname{1},struct('StringOptions',{props.(pname{1})}));
   end
   fprintf('\n');
   
end

end
