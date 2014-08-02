function link(obj,opt)
%HGWRAPPERLINK/LINK   Link objects
%   LINK(OBJS) links all the UIAXOBJ objects in OBJS. The linked objects
%   will be selected and unselected together. Previously established links
%   involving OBJS will be removed.
%
%   Derived class is responsible for the synchronization of linked objects
%   during mouse dragging. Utilize SETMASTER(OBJ) and CLRMASTER(OBJ)
%   methods.
%
%   LINK(OBJS,'off') removes the existing links involving OBJS

narginchk(1,2)
if nargin<2
   opt = 'on';
else
   opt = validatestring(opt,{'on','off'});
end

% only choose unique objects & put them in a row
objs = unique(obj);
objs = objs(:).'; % form a row

if strcmp(opt,'on')
   % create link

   % first remove all existing links
   link(objs,'off');

   % if scalar object array, no link
   if isscalar(objs), return; end

   % assign links
   for n = 1:numel(obj)
      objs(n).links = objs([1:n-1 n+1:end]);
   end
   
   % set link_master flag to true (indicating any of them can be the master)
   [objs.link_master] = deal(true);
   
else %if strcmp(opt,'off')
   % remove links

   objs = unique([objs [objs.links]]);
   [objs.links] = deal([]);
   [objs.link_master] = deal([]);
end
