function argin = processargin(obj,argin)
%HGPROPMODE/PROCESSARGIN   Process non-property constructor arguments
%   ARGIN = PROCESSARGIN(OBJ,ARGIN)

% if target info given, set it up now
if numel(argin)>1
   obj.setTarget(argin{1:3});
   argin(1:3) = [];
end
