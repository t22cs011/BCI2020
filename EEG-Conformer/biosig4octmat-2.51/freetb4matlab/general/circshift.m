

%# -*- texinfo -*-
%# @deftypefn {Function File} {@var{y} =} circshift (@var{x}, @var{n})
%# Circularly shifts the values of the array @var{x}.  @var{n} must be
%# a vector of integers no longer than the number of dimensions in 
%# @var{x}.  The values of @var{n} can be either positive or negative,
%# which determines the direction in which the values or @var{x} are
%# shifted.  If an element of @var{n} is zero, then the corresponding
%# dimension of @var{x} will not be shifted.  For example
%#
%# @example
%# @group
%# x = [1, 2, 3; 4, 5, 6; 7, 8, 9];
%# circshift (x, 1)
%# @result{}  7, 8, 9
%#     1, 2, 3
%#     4, 5, 6
%# circshift (x, -2)
%# @result{}  7, 8, 9
%#     1, 2, 3
%#     4, 5, 6
%# circshift (x, [0,1])
%# @result{}  3, 1, 2
%#     6, 4, 5
%#     9, 7, 8
%# @end group
%# @end example
%# @seealso {permute, ipermute, shiftdim}
%# @end deftypefn

function y = circshift (x, n)

  if (nargin == 2)
    if (isempty (x))
      y = x;
    else
      nd = ndims (x);
      sz = size (x);

      if (~ isvector (n) && length (n) > nd)
        error ('circshift: n must be a vector, no longer than the number of dimension in x');
      end
    
      if (any (n ~= floor (n)))
        error ('circshift: all values of n must be integers');
      end

      idx = cell ;
      for i = 1:length (n);
        nn = n(i);
        if (nn < 0)
          while (sz(i) <= -nn)
            nn = nn + sz(i);
          end
          idx{i} = [(1-nn):sz(i), 1:-nn];
        else
          while (sz(i) <= nn)
            nn = nn - sz(i);
          end
          idx{i} = [(sz(i)-nn+1):sz(i), 1:(sz(i)-nn)];
        end
      end
      for i = (length(n) + 1) : nd
        idx{i} = 1:sz(i);
      end
      y = x(idx{:});
    end
  else
    print_usage ;
  end


%!shared x
%! x = [1, 2, 3; 4, 5, 6; 7, 8, 9];

%!assert (circshift (x, 1), [7, 8, 9; 1, 2, 3; 4, 5, 6])
%!assert (circshift (x, -2), [7, 8, 9; 1, 2, 3; 4, 5, 6])
%!assert (circshift (x, [0, 1]), [3, 1, 2; 6, 4, 5; 9, 7, 8]);
%!assert (circshift ([],1), [])

%# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009 David Bateman
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
