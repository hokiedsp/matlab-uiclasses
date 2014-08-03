function a = set(obj,varargin)
%HGWRAPPER/SET   Set property values of HGWRAPPER object and its HG object.
%   SET(H,'PropertyName',PropertyValue) sets the value of the specified
%   property for the HGWRAPPER object H. If H is an array of objects, the
%   specified property's value is set for all objects in H.
%
%   SET(H,'PropertyName1',Value1,'PropertyName2',Value2,...) sets
%   multiple property values with a single statement.
%
%   SET(H,pn,pv) sets the named properties specified in the cell array of
%   strings pn to the corresponding values in the cell array pv for all
%   objects specified in H.  The cell array pn must be a vector of length
%   N, but the cell array pv can be 1-by-N or M-by-N, where M is equal to
%   length(H). If pv is 1-by-N, each property in pn is set to the same
%   value in all objects in H. If pv is M-by-N, each object will be
%   updated with a different set of values for the list of property names
%   contained in pn.
%
%   Given S, a structure array whose field names are object property
%   names, SET(H,S) sets the properties identified by each field name of
%   S with the values contained in the structure. S can have length 1 or
%   M, where M is equal to length(H). If S has length 1, each field name
%   in S sets the corresponding property for all objects in H. If S has
%   length M, each object will be updated with a different set of values
%   for the list of property names contained in pn.
%
%   A = SET(H, 'PropertyName') returns the possible values for the
%   specified property of the object with handle H. The returned array is
%   a cell array of possible value strings or an empty cell array if the
%   property does not have a finite set of possible string values.
%
%   SET(H,'PropertyName') displays the possible values for the specified
%   property of object with handle H.
%
%   Note that it is permissible to use property/value string pairs,
%   structures, and property/value cell array pairs in the same call to
%   SET.
%
%   A = SET(H) returns all property names and their possible values for
%   the object with handle H.  H must be scalar. The return value is a
%   structure whose field names are the property names of H, and whose
%   values are cell arrays of possible property values or empty cell
%   arrays.
%
%   SET(H) displays all properties and property values of scalar object
%   H.
%
%   The class can override the method SETDISP to control how information
%   is displayed in SET(H), A = SET(H), SET(H,'PropertyName') and A =
%   SET(H,'PropertyName').
%
%   See also: HGWRAPPER/CONFIGURE.

% SET(H): just display the options
if nargout==0 && nargin==1
   obj.setdisp();
   return;
end

if nargin==1 % A = SET(H)
   a = set@hgsetgetex(obj);
   if obj.isattached()
      a_hg = sethgprop(obj);
      anames = fieldnames(a_hg);
      for n = 1:numel(anames)
         aname = anames{n};
         if ~isfield(a,aname) % append only if hgwrapper class does not have the property of the same name
            a.(aname) = a_hg.(aname);
         end
      end
   end
   
elseif nargin==2 && ischar(varargin{1})% SET(H,'PropertyName')
   pname = varargin{1};
   try
      a = set@hgsetgetex(obj,pname);
   catch
      a = sethgprop(obj,pname);
   end
else % SET(H,'PropertyName',PropertyValue), SET(H,pn,pv), SET(H,S)
   % Since the properties must be set in the order given, each property must
   % be set separately

   varargin = hgsetgetex.unifyproppairs(varargin);
   if ischar(varargin{1}) %SET(H,'PropertyName',PropertyValue,...)
      Nargs = numel(varargin);
      n = 1;
      while n<=Nargs % process one property at time
         pname = varargin{n};
         if n==Nargs
            error('Invalid parameter/value pair arguments.');
         end
         pval = varargin{n+1};
         n = n + 2;
         
         if ischar(pname)
            try
               set@hgsetgetex(obj,pname,pval);
            catch ME
               if strcmp(ME.identifier,'MATLAB:class:InvalidProperty')
                  sethgprop(obj,pname,pval);
               else
                  ME.rethrow();
               end
            end
         end
      end
   else %SET(H,pn,pv)
      pname = varargin{1};
      pval = varargin{2};
      Np = numel(pname);
      if Np==0 && isempty(pval), return; end
      
      try
         validateattributes(pval,{'cell'},{'nrows',numel(obj),'ncols',Np});
      catch
         error('Invalid parameter/value pair arguments.');
      end
      
      for k = 1:Np
         name = pname(k);
         val = pval(:,k);
         
         try
            set@hgsetgetex(obj,name,val);
         catch ME
            if strcmp(ME.identifier,'MATLAB:class:InvalidProperty')
               sethgprop(obj,name,val);
            else
               ME.rethrow();
            end
         end
      end
   end
end

end

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
      a = set([obj.hg],pname);
   catch
      error('The name ''%s'' is not an accessible property for an instance of class ''%s''.',pname,class(obj));
   end
else
   try
      set([obj.hg],name,val);
   catch ME
      if strcmp(ME.identifier,'MATLAB:class:InvalidProperty')
         error('The name ''%s'' is not an accessible property for an instance of class ''%s''.',char(name),class(obj));
      else
         error('Bad property value found.\nObject Name: %s\nProperty Name: ''%s''\nError Message: %s',class(obj),char(name),ME.message);
      end
   end
end
end
