function populate_panel(obj)
%HGDISGUISE/POPULATE_PANEL   (protected) Populate panel with its content
%   POPULATE_PANEL(OBJ) performs 4 tasks:
%
%   0. Call uipanelex populate_panel()
%   1. Reassigns the attached transparent panel object from OBJ.hg to
%      OBJ.hpanel, and assigns its child (which is the original HG object
%      to be attached) as OBJ.hg.
%   2. Set up the background color to be the same as the hpanel parent's
%      and start the color change monitoring.
%   3. Update obj.propopts.Units.StringOptions to make sure all Units
%      options are covered for the hpanel Units
%   4. Set ResizeFcn of obj.hpanel

% uipanelex populate_panel (sets up Enable monitoring)
obj.populate_panel@uipanelautoresize();

% reassign HG handles
obj.hpanel = obj.hg;
obj.hg = handle(get(obj.hpanel,'Children'));

% match the background color of the transparent panel and add HG(panel)
% listeners to monitor change of parent
obj.monitor_bgcolor(get(obj.hpanel,'Parent'));
obj.hg_listener(end+1) = addlistener(obj.hpanel,'Parent','PostSet',@(~,data)obj.monitor_bgcolor(data.NewValue));

% update Units selection options
obj.propopts.Units.StringOptions = set(obj.hpanel,'Units');
