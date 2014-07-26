function populate_panel(obj)
%UISCROLLPANEL/POPULATE_PANEL   (protected) Populate panel with its content
%
% Format both window (obj.hg) and canvas (obj.hc) containers

% nothing to do if detached
if ~obj.isattached(), return; end

% create the other container
hgiswindow = any(strcmp(get(obj.hg,'type'),{'uipanel'}));
pnames = {'Parent','Visible','Units','Position'};
if hgiswindow % if uipanel specified, use obj.hg as the obj.hwindow container

   % get all existing child objects
   hchildren = get(obj.hg,'Children');
   
   % create new canvas panel
   hnew = handle(uicontainer('Parent',obj.hg,'Units','normalized','Position',[0 0 1 1]));
   obj.hwindow = obj.hg;
   obj.hcanvas = hnew;
   
   % Move all child objects to the canvas (maintaining the same positions)
   units = get(hchildren,{'Units'});
   set(hchildren,'Parent',obj.hcanvas);
   set(hchildren,{'Units'},units);
   
else % else use obj.hg as the obj.hcanvas container
   % for all other panel types, use h as the canvas container
   hnew = handle(uicontainer(pnames,get(obj.hg,pnames))); % create the new window on the same parent with the same visibility
   obj.hcanvas = obj.hg;
   obj.hwindow = hnew;
   
   % make canvas as a child of window and fit to the size
   set(obj.hcanvas,'Parent',obj.hwindow,'Units','normalized','Position',[0 0 1 1],'Units','pixels');
end

% copy all copyable properties
pvals = get(obj.hg);
pnew = fieldnames(set(hnew)).';
pvals = rmfield(pvals,[...
   pnames...
   setdiff(fieldnames(pvals),pnew).'...
   {'Children','Tag','UserData'}]);
set(hnew,pvals);

% create scrollbars (puts them on top of the canvas)
obj.hscrollbars = [...
   uicontrol('Parent',obj.hwindow,'Style','slider','Visible','off', ...
             'Units','pixels','Min',0, ...
             'Callback',@(~,~)obj.move_canvas(true,false)) ...
   uicontrol('Parent',obj.hwindow,'Style','slider','Visible','off', ...
             'Units','pixels','Min',0,'Max',1','Value',1,...
             'Callback',@(~,~)obj.move_canvas(false,true))...
   ];

% set ResizeFcn property of obj.hg to redraw canvas when resized
set(obj.hwindow,'ResizeFcn',@(~,~)obj.layout_panel());
obj.hg_listener(end+1) = addlistener(obj.hwindow,'ResizeFcn','PostSet',...
   @(~,event)obj.check_resizefcn(event.NewValue));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set ChildrenAdded listeners for obj.hg to automatically move added
% child over to canvas.
obj.hg_listener(end+1) = addlistener(obj.hwindow,'ObjectChildAdded',...
   @(~,event)set(event.Child,'Parent',obj.hcanvas));

% PROPERTY LISTENERS: properties are synchronized so that hcanvas and
% hwindow properties appear to be the same.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set listeners to synchronize on most of the common settable properties
phg = fieldnames(set(obj.hg));
pcommon = setdiff(intersect(phg,pnew),...
   {'Position','Units','Parent','Children','Tag','UserData',... % some exceptions
   'ButtonDownFcn','CreateFcn','DeleteFcn','ResizeFcn'});
for n = 1:numel(pcommon)
   obj.hg_listener(end+1) = addlistener(obj.hg,pcommon{n},'PostSet',@(~,event)set(hnew,pcommon{n},event.NewValue));
end

% now call uipanelex's to set up Enable monitoring
% - If hg is the canvas and not window, temporarily swap out obj.hg so that
%   uipanelex sets up Enable monitoring listeners on the window
if ~hgiswindow
   obj.hg = obj.hwindow;
end
obj.populate_panel@uipanelex();
if ~hgiswindow
   obj.hg = obj.hcanvas;
end

if hgiswindow
   % now redo the last hg_listener element (which were set up by uipanelex)
   % to anticipate content_listeners to be set up for the children of
   % hcanvas
   delete(obj.hg_listener(end));
   obj.hg_listener(end) = addlistener(obj.hcanvas,'ObjectChildRemoved',@(~,event)obj.delete_listeners(event.Child));
end
