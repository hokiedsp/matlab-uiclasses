function populate_panel(obj)
%DIALOGEX/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) covers the dialog figure with pnMain uicontainer,
%   which is controlled by OBJ.pnMain uiflowgridcontainer object. The upper
%   cell of OBJ.pnMain is occupied by a uicontainer object which is
%   assigned to OBJ.ContentPanel and the lower uicontainer forms the
%   control button group.

obj.populate_panel@uipanelautoresize();

obj.ContentPanel = uicontainer('Parent',obj.hg);
hbbox = uicontainer('Parent',obj.hg,'Units','pixels');

obj.pnButtonBox.attach(hbbox);

% create buttons
obj.hBtns = [
   uicontrol(hbbox,'Style','pushbutton','Visible',obj.btnvis{1},'Enable',obj.btnena{1},'Callback',@(~,~)obj.btncallback(1))
   uicontrol(hbbox,'Style','pushbutton','Visible',obj.btnvis{2},'Enable',obj.btnena{2},'Callback',@(~,~)obj.btncallback(2))
	uicontrol(hbbox,'Style','pushbutton','Visible',obj.btnvis{3},'Enable',obj.btnena{3},'Callback',@(~,~)obj.btncallback(3))
   ];
obj.setdefaultbutton();

obj.format_buttonbox();

% Set figure property monitors
obj.crfmode.setTarget(obj.hg,'CloseRequestFcn',@(~,~)obj.btncallback(1));
obj.wkpfmode.setTarget(obj.hg,'WindowKeyPressFcn',@(h,event)obj.windowskeypressfcn(h,event));

% Set figure property listeners to synchronize properties
obj.propsync(1).setSource(obj.hg,'Color');
obj.propsync(1).setTarget([obj.ContentPanel hbbox],'BackgroundColor');
obj.propsync(2).setSource(obj.hg,'ButtonDownFcn');
obj.propsync(2).setTarget([obj.ContentPanel hbbox]);
