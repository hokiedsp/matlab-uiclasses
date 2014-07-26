classdef hglisteners < handle
%HGLISTENERS   Cross-release compatible event listener managemenet class

properties (SetAccess=protected)
   EventListeners = event.listener.empty
   HandleListeners = handle([])
   ELDisableKeyPool
   HLDisableKeyPool
end

methods
   add(obj,el)               % add new listener
   el = remove(obj,varargin) % remove listener
   clear(obj)                % remove all listeners
   enable(obj,key)           % enable all listeners
   key = disable(obj)        % disable all listeners
   el = find(obj,varargin)   % find event listener
   h = getsources(obj)       % get event sources
   
   function delete(obj)
      delete(obj.EventListeners);
      delete(obj.HandleListeners);
   end
   
end

end
