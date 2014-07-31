function argin = autoattach(clsname,hgobj,types,argin)
%UIPANELEX/AUTOATTACH   Create new HG objects if the first argument is a handle
%object array or empty. The new objects are only created if the calling
%class constructor is explicitly invoked

% if HG handle not given, get type
if ~isempty(argin) && ~(all(ishghandle(argin{1}(:))) || isempty(argin{1}))
   [~,I] = uipanelex.getdimsinput(argin);
   Narg = numel(argin);
   if Narg>I && mod(Narg-I,2)>0 % ...,'type','PropertyName',... (must have odd # of remaining arguments)
      I = I + 1;
      hgobjin = argin{I};
      if ~(strcmpi(hgobjin,'detached') || isempty(which(argin{I})))
         % override hgobj argument if type is defined
         hgobj = str2func(argin{I});
         argin(I) = []; % remove type argument
      end
   end
end

% if non-property line arguments were not given, call superclass autoattach
argin = hgenable.autoattach(clsname,hgobj,types,argin);
