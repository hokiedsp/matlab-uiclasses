function argin = processargin(obj,argin)
%HGPROPSYNC/PROCESSARGIN   Process non-property constructor arguments
%   ARGIN = PROCESSARGIN(OBJ,ARGIN)

% if target info given, set it up now
if numel(argin)>1 && isscalar(argin{1}) && ishghandle(argin{1})
   obj.setSource(argin{1:2});
   argin(1:2) = [];
   if numel(argin)>1 && all(ishghandle(argin{1}))
      if mod(numel(argin),2)==0 % even #, target properties given
         obj.setTarget(argin{1:2});
         argin(1:2) = [];
      else
         obj.setTarget(argin{1});
         argin(1) = [];
      end
   end
end
