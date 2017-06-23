function e=eccentricity(image,centroid)
pixellist=regionprops(image,'pixellist') ;

total_list=[];
for i=1:numel(pixellist)
    total_list=[total_list;pixellist(i).PixelList];
end
list=total_list;    

if (isempty(list))
    MajorAxisLength = 0;
    MinorAxisLength = 0;
    Eccentricity = 0;      
else
    % Assign X and Y variables so that we're measuring orientation
    % counterclockwise from the horizontal axis.

    xbar = centroid(1);
    ybar = centroid(2);

    x = list(:,1) - xbar;
    y = -(list(:,2) - ybar); % This is negative for the
    % orientation calculation (measured in the
    % counter-clockwise direction).

    N = length(x);

    % Calculate normalized second central moments for the region. 1/12 is
    % the normalized second central moment of a pixel with unit length.
    uxx = sum(x.^2)/N + 1/12;
    uyy = sum(y.^2)/N + 1/12;
    uxy = sum(x.*y)/N;

    % Calculate major axis length, minor axis length, and eccentricity.
    common = sqrt((uxx - uyy)^2 + 4*uxy^2);
    MajorAxisLength = 2*sqrt(2)*sqrt(uxx + uyy + common);
    MinorAxisLength = 2*sqrt(2)*sqrt(uxx + uyy - common);
    Eccentricity = 2*sqrt((MajorAxisLength/2)^2 - ...
        (MinorAxisLength/2)^2) / ...
        MajorAxisLength;

     e=Eccentricity;
end
end
