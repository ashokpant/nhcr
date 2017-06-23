function [discoursed_image]=universe_of_discourse(image)
% Universe of discourse is defined as the shortest matrix that fits the
% entire character skeleton. The Universe of discourse is selected because
% the features extracted from the character image include the positions of
% different line segments in the character image. So every character image
% should be independent of its Image size.
% [row,col]=size(image);
% uppermost=1;
% lowermost=row;
% leftmost=1;
% rightmost=col;

currentimage=image;
[row,column]=size(currentimage);
for j=1:row
    currentrow=currentimage(j,:);
    temp=find(currentrow==1, 1);
    if isempty(temp)
        continue;
    else
        uppermost=j;
        break;
    end
end
for j=1:column
    currentcolumn=currentimage(:,j);
    temp=find(currentcolumn==1, 1);
    if isempty(temp)
        continue;
    else
        leftmost=j;
        break;
    end
end
for j=column:-1:1
    currentcolumn=currentimage(:,j);
    temp=find(currentcolumn==1, 1);
    if isempty(temp)
        continue;
    else
        rightmost=j;
        break;
    end
end
for j=row:-1:1
    currentrow=currentimage(j,:);
    temp=find(currentrow==1, 1);
    if isempty(temp)
        continue;
    else
        lowermost=j;
        break;
    end
end
discoursed_image=currentimage(uppermost:lowermost,leftmost:rightmost);
end