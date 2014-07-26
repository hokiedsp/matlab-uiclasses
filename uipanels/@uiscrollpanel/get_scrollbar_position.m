function [M0,m0,Mlen,mlen] = get_scrollbar_position(loloc,maxlen,hother,other_loclo,other_maxlen,th)
%UISCROLLPANEL/GET_SCROLLBAR_POSITION
%   [M0,m0,Mlen,mlen] = GET_SCROLLBAR_POSITION(loloc,maxlen,hother,other_loclo,other_maxlen,th)
%   loloc: true if placed at the low end ('bottom'|'left')
%   maxlen: maximum scrollbar length
%   hother: other scrollbar
%   other_loloc: true if other scrollbar is placed at the low end ('left'|'bottom')
%   other_maxlen: maximum length of the other scrollbar
%   th: scrollbar thickness

% if other scrollbar is visible
other_vis = strcmp(get(hother,'Visible'),'on');

% origin in major dimension
if other_vis && other_loclo % if vertical scrollbar is visible at left
   M0 = th+1;
else
   M0 = 1;
end

% size in major dimension
Mlen = maxlen-M0+1;
if other_vis && ~other_loclo % if vertical scrollbar is visible at right
   Mlen = Mlen - th;
end
Mlen = max(Mlen,th);

% origin in minor dimension
if loloc % 'bottom'|'left'
   m0 = 1;
else % 'top'|'right'
   m0 = other_maxlen-th+1;
end

% size in minor dimension
mlen = th;
