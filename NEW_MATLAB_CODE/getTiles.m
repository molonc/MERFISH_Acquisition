function [ItileXpos, ItileYpos, numXtiles, numYtiles] = getTiles(l, FOVx, FOVy, overlapx, overlapy)
        %Find distance between a and b
        AOIx = handles.List(l, 1) - handles.List(l, 3);
        AOIy = handles.List(l, 2) - handles.List(l, 4);
        
        %Number of tiles required to cover a to b
        numXtiles = ceil( (AOIx - overlapx) / (FOVx - overlapx) );
        numYtiles = ceil( (AOIy - overlapy) / (FOVy - overlapy) );
        
        %Ensure at least 1 tile
        if(numXtiles <= 0)
            numXtiles = 1;
        end
        if(numYtiles <= 0)
            numYtiles = 1;
        end
        

        centerXpos =handles.List(l, 1)-AOIx/2;
        centerYpos =handles.List(l, 2)-AOIy/2;     
        
        %Coordinates of first tile  
        if(mod(numXtiles,2))
            ItileXpos = centerXpos;
        else
            ItileXpos = centerXpos - (FOVx/2 - overlapx/2);
        end
        
        if(mod(numYtiles,2))
            ItileYpos = centerYpos;
        else
            ItileYpos = centerYpos - (FOVy/2 - overlapy/2);
        end
end