function close_all
% CLOSE_ALL   Closes all CRP windows.
%    Used by CRP Toolbox

% Copyright (c) 2008-
% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
% http://www.pik-potsdam.de
%
% Copyright (c) 1998-2008
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2016/03/03 14:57:23 $
% $Revision: 4.10 $
%
% $Log: close_all.m,v $
% Revision 4.10  2016/03/03 14:57:23  marwan
% updated input/output check (because Mathworks is removing downwards compatibility)
% bug in crqad_big fixed (calculation of xcf).
%
% Revision 4.9  2016/01/31 13:02:45  marwan
% fix compatibility issues (R2014b)
%
% Revision 4.8  2009/03/24 08:36:04  marwan
% copyright address updated
%
% Revision 4.7  2004/11/10 07:04:28  marwan
% initial import
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

global  props

  if ~isempty(findobj('Tag','CRPFig')), delete(findobj('Tag','CRPFig')), end
  root_ud=get(0,'UserData'); 
  if isstruct(root_ud)
    if isfield(root_ud,'crp')
      root_ud=rmfield(root_ud,'crp');
      if length(fieldnames(root_ud))==1
        if isfield(root_ud,'old'); root_ud=root_ud.old; end
      end
    end
  end
  try, set(0,'UserData',root_ud,props.root), end
  
  %clear all % does not work since MATLAB 2014
  disp('Thank you for using CRP toolbox.')
