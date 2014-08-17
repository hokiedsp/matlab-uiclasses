function p = ancestor(obj,varargin)
%HGWRAPPER/ANCESTOR   Get attached object ancestor
%   p = ancestor(OBJ,TYPE) returns the handle of the closest ancestor of h
%   that matches one of the types in TYPE, or empty if there is no matching
%   ancestor.  TYPE may be a single string (single type) or cell array of
%   strings (types). If H is a vector of handles then P is a cell array the
%   same length as H and P{n} is the ancestor of H(n). If H is one of the
%   specified types then ancestor returns H.
%
%   P = ANCESTOR(H,TYPE,'TOPLEVEL') finds the highest level ancestor of one
%   of the types in TYPE
%
%   If H is not an Handle Graphics object, ANCESTOR returns empty.
%
%   Examples:
%
%      p = ancestor(gca,'figure');
%      p = ancestor(gco,{'hgtransform','hggroup','axes'},'toplevel');

if isempty(obj)
   p = [];
   return;
end

if ~(isscalar(obj) || all(obj.isattached()))
   error('All elements of OBJ must have HG objects attached to them.');
end

if isscalar(obj)
   h = obj.hg;
else
   h = reshape([obj.hg],size(obj));
end

try
   p = ancestor(h,varargin{:});
catch ME
   ME.throwAsCaller();
end
