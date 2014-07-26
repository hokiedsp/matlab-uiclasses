function [ptrloc,ptrloc_px] = getptrloc(ax)
%GETPTRLOC   Get pointer location in axes data units
%   GETPTRLOC returns a 2-element vector containing the x- and
%   y-coordinates of the pointer position in the current axes.
%
%   GETPTRLOC(AX) gets the position in the axes with handle
%   AX.
%
%   See also: px2data.

if nargin<1, ax = gca; end

% get current pointer location in pixels
units_bak = get(0,'Units');  % save the original Units mode
set(0,'Units','pixels');
ptrloc_px = get(0,'PointerLocation');
set(0,'Units',units_bak);    % reset to the original Units mode

% get figure location in pixels
fig = ancestor(ax,'figure');
units_bak = get(fig,'Units');  % save the original Units mode
set(fig,'Units','pixels');
figloc_px = get(fig,'Position');
set(fig,'Units',units_bak);    % reset to the original Units mode

% move pointer coordinate origin from the screen origin to the figure origin
ptrloc_px(:) = ptrloc_px - figloc_px(1:2);

% convert to axis data units
ptrloc = px2data(ax,ptrloc_px);


% Copyright (c) 2011, Takeshi Ikuma
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   * Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer.
%   * Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%   * Neither the names of its contributors may be used to endorse or
%     promote products derived from this software without specific prior
%     written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
