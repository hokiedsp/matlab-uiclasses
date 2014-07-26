function psize = fitpanel2children(h,pad,dns)

% default to set
if nargin<3 || isempty(dns)
   dns = false;
end

hc = get(h,'Children');
hall = [h;hc(:)];

u = get(hall,{'Units'});
set(hall,'Units','pixels');

pos = cell2mat(get(hc,'Position'));
psize = max(pos(:,1:2)+pos(:,3:4))+pad; % get upper right most coordinate + padding
pos = get(h,'Position');
pos(3:4) = psize;
if ~dns
   set(h,'Position',pos,'UserData',psize); % 'UserData' to remember it as the minimum size allowed
end

set(hall,{'Units'},u);
end
