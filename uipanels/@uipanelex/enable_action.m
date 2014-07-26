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
ishgenable = false(size(I));
N = numel(obj.d_hgws);
for n = 1:numel(hgws)
   try % to save current Enable value
      ena = hgws(n).Enable;
      obj.d_hgw_states{N+1} = ena;
      
      % if success, proceed set Enable to match the panel's 
      % ... unless panel is inactive and obj is disabled
      if ~(strcmp(val,'inactive') && strcmp(ena,'off'))
         hgws(n).Enable = val;
      end
      
      % filling in the rest of the information
      ishgenable(n) = true;
      N = N + 1;
      obj.d_hgws(N) = hgws(n);
      obj.d_hgw_listeners(N) = addlistener(hgws(n),'Enable','PostSet',...
         @(~,~)obj.d_update(N,false));
   catch ME
      ME.rethrow();
   end
end

% remove HG objects with hgenable from h
I(~ishgenable) = [];
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
   lisena = get(lis,{'Enabled'});
   set(lis,'Enabled','off');
   set(h,'Enable',val);
   set(lis,{'Enabled'},lisena);
   
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
