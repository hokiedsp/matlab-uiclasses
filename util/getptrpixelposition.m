function ptrloc = getptrpixelposition(h)
%GETPTRPIXELPOSITION   Get pointer location with respect to HG object
%   GETPTRPIXELPOSITION(H) returns pointer position [x y] in pixels with
%   respect to the lower-left-hand corner of HG object H. H must not be an
%   axes child.
%
%   See also: px2data.

% pick the first figure children or place a new axes
if nargin<1
   h = findobj(gcf,'-property','Position','-property','Units');
   if numel(h)>1
      h([1 3:end]) = [];
   else
      h = h(1);
   end
end

% get h's origin in global coordinate
pos = getpixelposition(h,true);

units_bak = get(0,'Units');  % save the original Units mode
set(0,'Units','pixels');
ptr = get(0,'PointerLocation');
set(0,'Units',units_bak);    % reset to the original Units mode

fig = ancestor(h,'figure');
units_bak = get(fig,'Units');  % save the original Units mode
set(fig,'Units','pixels');
figpos = get(fig,'Position');
set(fig,'Units',units_bak);    % reset to the original Units mode


% move pointer coordinate origin from the screen origin to the figure origin
ptrloc = ptr - (figpos([1 2]) + pos([1 2]));


% Copyright (c) 2014, Takeshi Ikuma
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
