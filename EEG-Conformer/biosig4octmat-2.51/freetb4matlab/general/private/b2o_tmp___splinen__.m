

%# Undocumented internal function.

%# -*- texinfo -*-
%# @deftypefn {Function File} {@var{yi} =} __splinen__ (@var{x}, @var{y}, @var{xi})
%# Undocumented internal function.
%# @end deftypefn

%# FIXME: Allow arbitrary grids..

function yi = o2m_tmp___splinen__ (x, y, xi, extrapval, f)
  if (nargin ~= 5)
    error ('o2m_tmp___splinen__: Incorrect number of arguments');
  end
  %# ND isvector function.
  isvec = @(x) numel (x) == length (x);
  if (~iscell (x) || length(x) < ndims(y) || any (~ cellfun (isvec, x)) ||
      ~iscell (xi) || length(xi) < ndims(y) || any (~ cellfun (isvec, xi)))
    error ('o2m_tmp___splinen__: %s: non gridded data or dimensions inconsistent', f);
  end
  yi = y;
  for i = length(x):-1:1
    yi = permute (spline (x{i}, yi, xi{i}(:)), [length(x),1:length(x)-1]);
  end

  o2m_tmp_1 = cellfun (@(x) x(:), xi, 'UniformOutput', false);
[xi{:}] = ndgrid (o2m_tmp_1{:});
  idx = zeros (size(xi{1}));
  for i = 1 : length(x)
    idx = idx | (xi{i} < min (x{i}(:)) | xi{i} > max (x{i}(:)));
  end
  yi(idx) = extrapval;


%# Copyright (C) 2007, 2008, 2009 David Bateman
%#
%# This file is part of Octave.
%#
%# Octave is free software; you can redistribute it and/or modify it
%# under the terms of the GNU General Public License as published by
%# the Free Software Foundation; either version 3 of the License, or (at
%# your option) any later version.
%#
%# Octave is distributed in the hope that it will be useful, but
%# WITHOUT ANY WARRANTY; without even the implied warranty of
%# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%# General Public License for more details.
%#
%# You should have received a copy of the GNU General Public License
%# along with Octave; see the file COPYING.  If not, see
%# <http://www.gnu.org/licenses/>.
