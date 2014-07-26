function varargout = setLockCtrl(obj,varargin)
%HGLOCKABLE/SETLOCKCTRL   Set HG properties of lock uicontrol object
%   SETLOCKCTRL(OBJ,'PropertyName',PropertyValue) sets the value of the
%   specified property for the lock graphics object in HGLOCKABLE object
%   OBJ.
%  
%   SETLOCKCTRL(OBJ,a) where a is a structure whose field names are object
%   property names, sets the properties named in each field name with the
%   values contained in the structure.
%  
%   SETLOCKCTRL(OBJ,pn,pv) sets the named properties specified in the cell
%   array of strings pn to the corresponding values in the cell array pv
%   for all objects specified in H.  The cell array pn must be 1-by-N, but
%   the cell array pv can be M-by-N where M is equal to length(H) so that
%   each object will be updated with a different set of values for the list
%   of property names contained in pn.
%  
%   SETLOCKCTRL(OBJ,'PropertyName1',PropertyValue1,'PropertyName2',PropertyValue2,...)
%   sets multiple property values with a single statement.  Note that it is
%   permissible to use property/value string pairs, structures, and
%   property/value cell array pairs in the same call to set.
%  
%   A = SETLOCKCTRL(OBJ,'PropertyName') 
%   SETLOCKCTRL(OBJ,'PropertyName')
%   returns or displays the possible values for the specified property of
%   the object with handle H.  The returned array is a cell array of
%   possible value strings or an empty cell array if the property does not
%   have a finite set of possible string values.
%     
%   A = SETLOCKCTRL(OBJ) 
%   SETLOCKCTRL(OBJ) 
%   returns or displays the names of the user-settable properties and 
%   their possible values for the object with handle H.  The return value 
%   is a structure whose field names are the user-settable property names 
%   of H, and whose values are cell arrays of possible property values or 
%   empty cell arrays.

if nargout>0
   [varargout{:}] = set([obj.aux_h],varargin{:});
else
   set([obj.aux_h],varargin{:});
end
