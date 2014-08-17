function followAxes(obj,ax,loc,offset)
%UIZOOMCTRL/FOLLOWAXES   Automatic positioning wrt an axes
%   FOLLOWAXES(OBJ,AX) places the UIZOOMCTRL OBJ at just outside the lower
%   left corner of the axes with handle AX. If AX is moved, OBJ will follow
%   AX.
%
%   FOLLOWAXES(OBJ,AX,LOC) specifies the exact placement of OBJ wrt AX. LOC
%   may be any of the following:
%
%     'NorthEast'         outside top right
%     'NorthWest'         outside top left
%     'SouthEast'         outside bottom right
%     'SouthWest'         outside bottom left (default)
%     'NorthEastInside'   inside top right
%     'NorthWestInside'   inside top left
%     'SouthEastInside'   inside bottom right
%     'SouthWestInside'   inside bottom left
%
%   The exact placement of OBJ depends on its Oriendtation property. If
%   OBJ.Oriendtation = 'horizontal' OBJ is placed along the vertical edge
%   of AX; if = 'vertical' OBJ is placed along the horizontal edge of AX.
%
%   FOLLOWAXES(OBJ,[]) stops the automatic following of AX.

narginchk(2,4)

% only set valid objects
if isempty(obj), return; end % no object, exit
if ~(isscalar(obj) && obj.isattached())
   error('OBJ must be scalar and attached.');
end

if ~(isempty(ax) || (isscalar(ax) && ishghandle(ax) && strcmp(get(ax,'Type'),'axes')))
   error('AX must either be empty or a valid axes object handle.');
end
if ~isequal(get(obj.hg,'Parent'),get(ax,'Parent'))
   error('AX must have the same parent as the UIZOOMCTRL panel.');
end

if nargin<3
   lcode = [false false true]; % 'SouthWest'
else
   opts = {'NorthEast','NorthWest','SouthEast','SouthWest',...
      'NorthEastInside','NorthWestInside','SouthEastInside','SouthWestInside'};
   loc = validatestring(loc,opts);
   tok = regexp(loc,'(North|South)(East|West)(Inside)?','once','tokens');
   lcode = [tok{1}=='N' tok{2}=='E' isempty(tok{3})];
end

if nargin<4
   offset = 0;
else
   validateattributes(offset,{'numeric'},{'scalar','finite'});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
   delete(obj.el_axpos);
catch
end
obj.el_axpos(:) = [];

if ~isempty(ax)
   axes_pos_postset(obj.hg,ax,lcode,offset);
   obj.el_axpos = addlistener(ax,'Position','PostSet',...
      @(~,~)axes_pos_postset(obj.hg,ax,lcode,offset));
end

end

function axes_pos_postset(h,ax,lcode,offset)

u = get(ax,'Units');
set(ax,'Units','pixels');
axpos = get(ax,'Position');
set(ax,'Units',u);

u = get(h,'Units');
set(h,'Units','pixels');
hpos = get(h,'Position');

hpos([1 2]) = axpos([1 2]); % align the bottom left corners of H and AX

if hpos(3)>hpos(4) % wide -> along x-axis
   if lcode(1) % 'North'
      hpos(2) = hpos(2) + axpos(4);
      if ~lcode(3) % Inside
         hpos(2) = hpos(2) - hpos(4);
      end
   elseif lcode(3) % 'South' 'Outside'
      hpos(2) = hpos(2) - hpos(4) - 1;
   end
   
   if lcode(2) % 'East'
      hpos(1) = hpos(1) + axpos(3) - hpos(3) - offset;
   else % 'West'
      hpos(1) = hpos(1) + offset;
   end
else % tall
   if lcode(2) % 'East'
      hpos(1) = hpos(1) + axpos(3);
      if ~lcode(3) % Inside
         hpos(1) = hpos(1) - hpos(3);
      end
   elseif lcode(3) % 'West' 'Outside'
      hpos(1) = hpos(1) - hpos(3) - 1;
   end
   
   if lcode(1) % 'North'
      hpos(2) = hpos(2) + axpos(4) - hpos(4) - offset;
   else % 'South'
      hpos(2) = hpos(2) + offset;
   end
end

set(h,'Position',hpos,'Units',u);

end
