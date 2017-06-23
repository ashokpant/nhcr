function direction=finddirection(first,second)
% This function two neighbour pixels and finds direction of second pixel
% with respect to first pixel. 

%First pixel is considered to be center pixel.The numbering is in clockwise
%direction. The pixel below central pixel is numbered as 1 and the rest are
%numbered in clockwise direction.


direction=0;
position = second-first;
if     position==[1,0]
    direction=1;
elseif position==[1,-1]
    direction=2;
elseif position==[0,-1]
    direction=3;
elseif position==[-1,-1]
    direction=4;
elseif position==[-1,0]
    direction=5;
elseif position==[-1,1]
    direction=6;
elseif position==[0,1]
    direction=7;
elseif position==[1,1]
    direction=8;
end