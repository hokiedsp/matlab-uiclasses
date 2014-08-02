function prop_postsetfcn(obj,newval)
%HGPROPSYNC/PROP_POSTSETFCN   Property PostSet event callback
%   PROP_POSTSETFCN(OBJ) sets the value changed flag.

if strcmp(get(obj.SourceHandle,'BeingDeleted'),'on')
   return;
end

try % just in case
   if isempty(obj.TargetProperties) % same property as the source
      set(obj.TargetHandles,obj.SourceProperty,newval);
   elseif ischar(obj.TargetProperties) % all same
      set(obj.TargetHandles,obj.TargetProperties,newval);
   else % all different
      for n = 1:numel(obj.TargetHandles)
         set(obj.TargetHandles(n),obj.TargetProperties{n},newval);
      end
   end
catch
end
