function varargout = getLockCtrl(obj,varargin)
%HGLOCKABLE/GETLOCKCTRL   Get HG properties of lock uicontrol object
%   V = GETLOCKCTRL(OBJ,'PropertyName') returns the value of the specified
%   property for the lock HG object of the HGLOCKABLE object with handle
%   OBJ.  If OBJ is a vector of handles, then get will return an M-by-1
%   cell array of values where M is equal to length(OBJ).  If
%   'PropertyName' is replaced by a 1-by-N or N-by-1 cell array of strings
%   containing property names, then get will return an M-by-N cell array of
%   values.
%  
%   GETLOCKCTRL(OBJ) displays the names and current values of all
%   user-gettable properties for the graphics object with handle OBJ.
%  
%   V = GETLOCKCTRL(OBJ) where H is a scalar, returns a structure where
%   each field name is the name of a user-gettable property of OBJ and each
%   field contains the value of that property.

if nargout>0
   [varargout{:}] = get([obj.aux_h],varargin{:});
else
   get([obj.aux_h],varargin{:});
end
