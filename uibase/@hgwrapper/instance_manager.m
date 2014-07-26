function varargout = instance_manager(command,varargin)
%HGWRAPPER/INSTANCE_MANAGEER (static, protected)
%   HGWRAPPER.INSTANCE_MANAGEER('add',OBJ)  <- only called by HGWRAPPER constructor
%   HGWRAPPER.INSTANCE_MANAGEER('remove',OBJ) <- only called by HGWRAPPER delete
%   HGWRAPPER.INSTANCE_MANAGEER('update',OBJ) <- called by HGWRAPPER attach & delete
%   OBJS = HGWRAPPER.INSTANCE_MANAGEER('find',H,...)
%   OBJS = HGWRAPPER.INSTANCE_MANAGEER('find',CLASSNAME,...)
%   OBJS = HGWRAPPER.INSTANCE_MANAGEER('mixedfind',...)
%   OBJS = HGWRAPPER.INSTANCE_MANAGEER('mixedfind',H,...) looks for HGWRAPPER object attached to handle H

persistent objs types hgs

if ~isa(handle([]),'handle')
   objs = handle([]);
end

switch lower(command)
   case 'add' % add new HGWRAPPER object to the list
      narginchk(2,2);
      add(varargin{1});
   case 'remove' % remove from the list
      narginchk(2,2);
      remove(varargin{1});
   case 'update' % update HG association
      narginchk(2,2);
      add(varargin{1});
   case 'find' % lookfor matching HGWRAPPER objects of a same class
      narginchk(1,inf);
      if nargin==1 % return all objects
         varargout{1} = objs;
         varargout{2} = [];
      else
         if nargout==0
            varargout{1} = find(varargin{:});
         else
            [varargout{1:nargout}] = find(varargin{:});
         end
      end
   case 'mixedfind' % lookfor matching HGWRAPPER objects of mixed classes
      narginchk(2,inf);
      varargout{1} = mixedfind(varargin{:});
end

% keep persistent variables secure by locking the m-file when hgwrapper
% instances are still present
if isempty(objs)
   munlock;
elseif ~mislocked
   mlock;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   function add(obj)
      
      if isempty(obj)
         return;
      end

      % make sure OBJ is given as a handle object
      obj = handle(obj);
      
      % create new entry for list
      type = {class(obj)};
      if isempty(objs) % new list
         N = numel(obj);
         idx = 1:N;
         objs = obj;
         hgs = handle([]);
         hgs(idx,1) = handle(-1);
         types = repmat(type,N,1);
      else % update if already exists or append at the end
         
         % first look for the object already in the system
         [existing_obj,I,Iexist] = intersect(obj,objs);
         obj(I) = [];
         
         % update existing objects first
         for n = 1:numel(Iexist)
            if existing_obj(n).isattached()
               hgs(Iexist(n)) = handle(existing_obj(n).GraphicsHandle);
            else
               hgs(Iexist(n)) = handle(-1);
            end
         end
         
         % append the new objects at the end
         N = numel(obj);
         Ncur = numel(objs);
         idx = (Ncur+1):(Ncur+N);
         objs(idx,1) = obj;
         hgs(idx,1) = handle(-1);
         types(idx,1) = type;
      end
      hgs(idx(obj.isattached)) = handle([obj.GraphicsHandle]);
   end

   function remove(obj) % called exclusively by HGWRAPPER destructor
      % OBJ is guaranteed to be scalar object
      
      if isempty(objs), return; end % just in case "clear all" has been called
      
      % make sure OBJ is given as a handle object
      obj = handle(obj);
      
      [~,I] = intersect(objs,obj);
      objs(I) = [];
      hgs(I) = [];
      types(I) = [];
      
   end

   function [obj,J] = find(type,varargin)
      if all(ishghandle(type))
         [~,I,J] = intersect(hgs,handle(type(:)));
         if isempty(I)
            obj = handle([]);
         else
            obj = objs(I);
         end
      else
         if ~(ischar(type)&&isrow(type))
            error('Type must be a string.');
         end
         I = strcmpi(types,type);
         if isempty(I)
            obj = [];
         else
            obj = [objs{I}];
         end
      end
      
      if isempty(varargin), return; end
      
%       Narg = nargin-1;
%       n = 1;
%       I = true(size(obj));
%       nextop = @and;
%       while n<Narg
%          var = varargin{1};
%          if ischar(var) && var(1)=='-'
%             
%          else
%             
%          end
%       end
   end

   function obj = mixedfind(varargin)
      h = varargin{1};
      if all(ishghandle(h))
         varargin(1) = [];
         [~,I] = intersect(hgs,h);
         obj = objs(I);
      else
         obj = objs;
      end

      if isempty(varargin), return; end
   end
end
