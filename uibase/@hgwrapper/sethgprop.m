function a = sethgprop(obj,name,val)
%HGWRAPPER/SETHGPROP   Helper function for SET method
%   SETHGPROP(OBJ,NAME,VAL) sets the value of OBJ's property with its
%   name given in NAME as VAL.
%
%   A = SETHGPROP(OBJ,NAME) returns the possible values for the property
%   specified by NAME.

if nargin<2
   a = set(obj.hg);
elseif nargin<3 % return
   try
      a = set(obj.hg,pname);
   catch
      error('The name ''%s'' is not an accessible property for an instance of class ''%s''.',pname,class(obj));
   end
else
   try
      set([obj.hg],name,val);
   catch ME
      if strcmp(ME.identifier,'MATLAB:class:InvalidProperty')
         error('The name ''%s'' is not an accessible property for an instance of class ''%s''.',name,class(obj));
      else
         error('Bad property value found.\nObject Name: %s\nProperty Name: ''%s''\nError Message: %s',class(obj),char(name),ME.message);
      end
   end
end
