function mode = enable_action(obj)
%UIPANELEX/ENABLE_ACTION   (protected) Set controls according to the new Enable state
%   MODE = ENABLE_ACTION(OBJ) is called when OBJ.Enable is changed. The
%   function returns the uint8 MODE indicating the new state:
%
%      0 - 'on'
%      1 - 'off'
%      2 - 'inactive'
%
%   MODE may be useful for an overriding subclass ENABLE_ACTION
%   functions.

mode = obj.enable_action@hgenable();

% special action only when a panel is attached
if isempty(obj.hg), return; end

val = obj.Enable;
if mode==0 % if enabled, restore Enable states of the descendent objects
   obj.d_revert();
elseif isempty(obj.d_hgs) && isempty(obj.d_hgws) % if enabled -> disabled/inactivated
   % traverse down the tree to save current state & start Enable listeners
   traverse_hgtree(obj,get(obj.GraphicsHandle,'Children'),val);
else
   update_enable(obj,val);
end

% if panel is uipanel, set enable state on its title
try
   title = get(obj.hg,'TitleHandle');
   set(title,'Enable',val);
catch
end

end

function traverse_hgtree(obj,h,val)

% first process
[hgws,I] = hgwrapper.findobj(h);
nothgenable = false(size(I));
N = numel(obj.d_hgws);
for n = 1:numel(hgws)
   
   % must be hgenable (or its derivatives)
   if ~isa(hgws(n),'hgenable')
      nothgenable(n) = true;
      continue;
   end
   
   N = N + 1;
   
   % to save current Enable value
   ena = hgws(n).Enable;
   obj.d_hgw_states{N} = ena;
   
   % if success, proceed set Enable to match the panel's
   % ... unless panel is inactive and obj is disabled
   if ~(strcmp(val,'inactive') && strcmp(ena,'off'))
      hgws(n).Enable = val;
   end
   
   % filling in the rest of the information
   obj.d_hgws(N) = hgws(n);
   obj.d_hgw_listeners(N) = addlistener(hgws(n),'Enable','PostSet',...
      @(~,~)obj.d_update(N,false));
end

% remove HG objects with hgenable from h
I(nothgenable) = [];
if ~isempty(I)
   h(I) = [];
end

% process remaining HG objects
for n = 1:numel(h)
   try % to read Enable property
      ena = get(h(n),'Enable');
      obj.d_hg_states{end+1} = ena;
      
      % if success, proceed set Enable to match the panel's
      % ... unless panel is inactive and obj is disabled
      if ~(strcmp(val,'inactive') && strcmp(ena,'off'))
         set(h(n),'Enable',val);
      end
      
      % filling in the rest of the information
      N = numel(obj.d_hgs) + 1;
      obj.d_hgs(N) = handle(h(n));
      obj.d_hg_listeners(N) = addlistener(h(n),'Enable','PostSet',...
         @(~,~)obj.d_update(N,true));
   catch ME
      if strcmp(ME.identifier,'MATLAB:class:InvalidProperty')
         try % to traverse down to the Children
            traverse_hgtree(obj,get(h(n),'Children'),val);
         catch ME
            if ~strcmp(ME.identifier,'MATLAB:class:InvalidProperty')
               ME.rethrow();
            end
         end
      elseif strcmp(ME.identifier,'MATLAB:hg:propswch:FindObjFailed')
         % likely due to trying to set Enable with no 'inactive' support to
         % 'inactive', just disable and move on
         set(h(n),'Enable','off');
      else
         ME.rethrow();
      end
   end
end
end

function update_enable(obj,val)
   % panel's Enable is toggled between 'off' and 'inactive'
   
   h = obj.d_hgws;
   lis = obj.d_hgw_listeners;
   idx = strcmp(val,'inactive') & strcmp(obj.d_hgw_states,'off');
   h(idx) = [];
   lis(idx) = [];
   if ~isempty(lis)
      lisena = {lis.Enabled};
      [lis.Enabled] = deal(false);
      set(h,'Enable',val);
      [lis.Enabled] = deal(lisena{:});
   end
   
   h = obj.d_hgs;
   lis = obj.d_hg_listeners;
   idx = strcmp(val,'inactive') & strcmp(obj.d_hg_states,'off');
   h(idx) = [];
   lis(idx) = [];
   lisena = get(lis,{'Enabled'});
   set(lis,'Enabled','off');
   set(h,'Enable',val);
   set(lis,{'Enabled'},lisena);
end
