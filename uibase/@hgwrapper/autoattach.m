function argin = autoattach(clsname,hgobj,supportedtypes,argin)
%HGWRAPPER/AUTOATTACH   Create new HG object for HGWRAPPER object in construction
%   ARGIN_MODIFIED = AUTOATTACH(CLASSNAME,CREATEHGFCN,ARGIN_ORIGINAL)
%   create new HG objects for the new class with the name CLASSNAME, by
%   executing:
%
%      H = CREATEHGFCN('Parent',p,'Visible',vis);
%
%   where 'Parent' and 'Visible' properties are assigned only if they are
%   given in the ARGIN_ORIGINAL cell array (which should be the varargin
%   input argument of the constructor).
%
%   If an array of object is being constructed, H will have the same size
%   as the eventual object size, determined from the dimensional arguments
%   in ARGIN_ORIGINAL.
%   
%   There are a few required conditions for new HG objects to be created:
%
%   1. First argument (ARGIN_ORIGINAL{1}) shall not be an HG object array.
%   2. The function call stack must contain the class constructor only once
%      and does not contain a call to subsasgn.
%   3. ARGIN_ORIGINAL, prior to the property name-value list, does not
%      contain a string 'detached', which is reserved keyword to return
%      detached HG object.
%
%   Upon completion, the new input argument cell array, ARGIN_MODIFIED, is
%   formed with the created HG array as its first argument, followed by the
%   unused ARGIN_ORIGINAL elements.

Narg = numel(argin);
if Narg>0
   h = argin{1}(:);
   % empty argument -> detached sclar object
   if isempty(h)
      return;
   end
   % check if HG handles are given as the first argument
   if all(ishghandle(h)) && all(ishghandle(h)) && numel(unique(h))==numel(h) ...
         && (Narg==1 || ~isnumeric(argin{2}))
      if isempty(supportedtypes), return; end % supports any type
      
      % make sure it is valid type
      if isempty(setdiff(get(h,'Type'),supportedtypes,'stable'))
         return;
      end
   end
end

% Step 1: Check the function call stack and make sure it is the explicit
% constructor call: i.e., call stack should not contain any
% clsname.clsname and subsasgn
st = dbstack();
fcnnames = {st.name};
if sum(strcmp(fcnnames,sprintf('%s.%s',clsname,clsname)))>1 ...
      || any(strcmp(fcnnames,'subsasgn'))
   return;
end

% Step 2: Get object dimension
[sz,Iend] = hgwrapper.getdimsinput(argin);

% Step 3: Check if called with 'detached' option
if numel(argin)>Iend
   try %#ok
      validatestring(argin{Iend+1},{'detached'});
      argin = [{[]} sz argin(Iend+2:end)]; % insert empty argument up front to indicate detached
      return;
   catch % continue on
   end
end

% Step 4: Check if GraphicsHandle property is given
%  Also look for 'parent' and 'visible' properties
[HgGiven,prt,vis,argin] = hgwrapper.getcritcalhgprops(argin,Iend);
if HgGiven, return; end

% Step 5: generate new HG object

% needs R2014b compatibility fix here
h = zeros(sz{:});

if isscalar(prt)
   prt = repmat(prt,sz{:});
end
if isscalar(vis)
   vis = repmat(vis,sz{:});
end

parg = {};
varg = {};
for n = 1:numel(h)
   if ~isempty(prt) && ~isempty(prt{n})
      parg = {'Parent',prt{n}};
   end
   if ~isempty(vis) && ~isempty(vis{n})
      varg = {'Visible',vis{n}};
   end
   h(n) = hgobj(parg{:},varg{:});
end

% prepend the HG object handles to the argument list
argin = [{h} argin];
