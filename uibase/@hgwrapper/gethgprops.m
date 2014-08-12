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
