function [starters_list,intersections] = starter_intersection(image)
% This function returns all the starters and intersections present in
% given image.

% Starter points are those with only one neighbour.
% Intersections are those pixels with 3 or more neighbours.

% The work in this code is based on a paper 'A novel feature extraction
% technique for the recognition of segmented handwritten characters' by
% Blumenstein, Verma and H.Basli. ( See section 2.3.1)



% I am going to add a border of zeros on all 4 sides of the orginal image
image=[image,zeros(size(image,1),1)];   % appending zeros on right border
image=[zeros(1,size(image,2));image];   % appending zeros on top border
image=[zeros(size(image,1),1),image];   % appending zeros on left border
image=[image;zeros(1,size(image,2))];   % appending zeros on bottom border
% adding zeros on all borders makes all (x,y) as (x+1,y+1)
row=size(image,1);
column=size(image,2);
starters_list=[];
intersections=[];

for m=2:(row-1)
    for n=2:(column-1)
        if (image(m,n)==1)
            neighberhood=image(m-1:m+1,n-1:n+1);
            neighbours=numel(find(neighberhood==1))-1;
            if neighbours==1
                starters_list=[starters_list;[m,n]];
            end
            if neighbours==3 %for explanation refer bottom section
                surrounders=findneighbours(image,[m,n]);
                cornerpixels=0;
                directpixels=0;
                directions=[];
                trueneighbours=3;
                for i=1:3
                    currentdirection=finddirection([m,n],surrounders(i,:));
                    directions=[directions,currentdirection];
                end
                for i=1:3
                    currentdirection=directions(i);
                    if currentdirection==1
                        adjacency=find(directions==8 | directions==2, 1);
                        if isempty(adjacency)
                            continue;
                        else
                            trueneighbours=trueneighbours-1;
                            break;
                        end
                    elseif currentdirection==8
                        adjacency=find(directions==7 |directions==1, 1);
                        if isempty(adjacency)
                            continue;
                        else
                            trueneighbours=trueneighbours-1;
                            break;
                        end                        
                    else
                        adjacency=find(directions==currentdirection-1 | directions==currentdirection+1);
                        if isempty(adjacency)
                            continue;
                        else
                            trueneighbours=trueneighbours-1;
                            break;
                        end
                    end
                end                
                if trueneighbours==3
                    intersections=[intersections;[m,n]];
                end
            end
            if neighbours==4
                surrounders=findneighbours(image,[m,n]);
                cornerpixels=0;
                directpixels=0;
                for i=1:4
                    currentdirection=finddirection([m,n],surrounders(i,:));
                    if(rem(currentdirection,2)==0) %bottom pixel is 1 and then pixels are numbered clockwise around the center pixel
                        cornerpixels=cornerpixels+1;
                    else
                        directpixels=directpixels+1;
                    end
                end
                if cornerpixels~=2
                    intersections=[intersections;[m,n]];
                end
            end
            if neighbours>4
                intersections=[intersections;[m,n]];
            end
        end
    end
end
starters_list=starters_list-1; % compensating for the shift in co-ordinate system
intersections=intersections-1; 
%Consider matrix [1 1 0
%                 0 1 0
%                 0 0 1]
% According to the definition of intersections the central pixel here will
% be considered as a intersection since it has more than two neighbours,
% but obviously its not an intersection!!!!. This only happens in cases
% where there are 3 neighbours. Consider that you are travelling along the
% skeleton of the image. Lets say you came to the central pixel from the
% down-right pixel. Now since that central pixel has two ways to go ( up
% and up-left), the code considers it as intersection. This behaviour
% should be modified. The way is to check if this two remaining neigbhours
% are adjacent in that 3*3 window. For this, its enough to check whether
% they are in same row or column.

% Another problem with the code is that consider letter 'C'. A possible
% occurence is [1 1 1 1
%     1 0 0 0
%     1 1 1 1]
%     here consider the pixel (2,1), it has 4 neighbours. So it will be
%     classified as a intersection, but its not. I will have to see to this