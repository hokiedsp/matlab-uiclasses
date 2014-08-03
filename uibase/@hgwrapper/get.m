function varargout = get(obj,varargin)
%HGWRAPPER/GET   Get properties of HGWRAPPER object and attached HG object
%   V = GET(H, 'PropertyName') returns the value of the specified property
%   for the HGWRAPPER object with handle H. Properties of both HGWRAPPER
%   object and its attached HG object can be requested. If H is an array of
%   handles, GET returns an M-by-1 cell array of values, where M is equal
%   to length(H). If 'PropertyName' is replaced by a 1-by-N or N-by-1 cell
%   array of strings containing property names, GET returns an M-by-N cell
%   array of values.  For non-scalar H, if 'PropertyName' is a dynamic
%   property, GET returns a value only if the property exists in all
%   objects of the array.
%
%   V = GET(H) returns a structure in which each field name is the name of
%   a user-gettable property of H and each field contains the value of that
%   property.  If H is non-scalar, GET returns a struct array with
%   dimensions M-by-1, where M = numel(H).  If H is non-scalar, GET does
%   not return dynamic properties.
%
%   GET(H) displays the names of all user-gettable properties and their
%   current values for the MATLAB object with handle H.  The class can
%   override the GETDISP method to control how this information is
%   displayed.  H must be scalar.
%
%   See also GET, HGWRAPPER, HGWRAPPER/GETDISP, HANDLE

narginchk(1,2)

if isempty(obj)
   if nargout>0
      if nargin==1 % struct output
         varargout{1} = struct([]);
      elseif iscellstr(varargin{1}) % cell output
         varargout{1} = {};
      else
         varargout{1} = [];
      end
   end
   return;
end

if ~all(obj.isvalid())
   error('Invalid or deleted object.');
end

if nargin==2 % property name(s) given
   pisch = ischar(varargin{1});
   if pisch
      pnames = varargin(1);
      N = 1;
   else
      pnames = varargin{1};
      N = numel(pnames);
   end
   
   M = numel(obj);
   v = cell(M,N); % property value to output
   objpnames = properties(obj);
   [tf,J] = ismember(lower(pnames),lower(objpnames));   % true if HGWRAPPER object properties
   
   if any(tf)
      v(:,tf) = obj.get@hgsetgetex(objpnames(J(tf)));
   end

   tf(:) = ~tf;
   if any(tf)
      if ~all(obj.isattached())
         error('Not accessible properties for an detached instance of class ''%s''.',class(obj));
      else
         v(:,tf) = gethgprops(obj,pnames(tf));
      end
   end
   
   if pisch && M==1
      varargout{1} = v{1};
   else
      varargout{1} = v;
   end
else % all properties
   if nargout>0 % return struct full of property values
      f1 = properties(obj);
      v1 = obj.get@hgsetgetex(f1).';
      [v2,f2] = gethgprops(obj);
      
      [f2,I] = setdiff(f2,f1,'stable');
      fnames = cat(1,f1,f2);
      fvals = cat(1,v1,v2(I));
      varargout{1} = cell2struct(fvals,fnames,1);
   else % display 
      getdisp(obj);
   end
end

end

function [vals,names] = gethgprops(obj,names)
%HGWRAPPER/GETPROPS   Helper function for GET method
%   VALS = GETHGPROPS(OBJ,NAMES) returns the values of OBJ's properties
%   with their names given in NAME cellstr array.
%
%   [VALS,NAMES] = GETHGPROPS(OBJ) returns values and names of all the
%   properties of the attached HG object

if nargin<2
   v = get(obj.hg);
   if isempty(v)
      vals = {};
      names = {};
   else
      names = fieldnames(v);
      vals = struct2cell(v);
   end
else
   vals = get([obj.hg],names);
end
end
