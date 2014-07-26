function [obj,I] = findobj(varargin)
%HGWRAPPER/FINDOBJ   Find hgwrapperobjects with specified property values.
%   OBJ = FINDOBJ(H) returns an hgwrapper object, which is attached to
%   HG object with handle H.

%   OBJ = FINDOBJ('P1Name',P1Value,...) returns a cell array of the handles
%   of the HGWRAPPER (or its subclass) objects whose property values match
%   those passed as param-value pairs to the FINDOBJ command.
%
%   OBJ = FINDOBJ returns the handles all HGWRAPPER objects.
%
%   OBJ = FINDOBJ('P1Name', P1Value, '-logicaloperator', ...) applies the
%   logical operator to the property value matching. Possible values for
%   -logicaloperator are -and, -or, -xor, -not.
%
%   H = FINDOBJ('-property', 'P1Name') finds all objects having the
%   specified property.

narginchk(0,inf);

[obj,I] = hgwrapper.instance_manager('find',varargin{:});

end
