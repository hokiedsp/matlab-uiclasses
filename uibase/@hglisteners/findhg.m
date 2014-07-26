function el = find(obj,varargin)
%HGLISTENER_MANAGER/FIND   Find listeners
%   FIND(OBJ,'P1Name',P1Value)

el = findobj(obj.Listeners,varargin{:});
