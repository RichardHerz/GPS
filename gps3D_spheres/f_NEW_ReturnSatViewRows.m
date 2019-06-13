function rowView = f_NEW_ReturnSatViewRows(xyz,xyzRec,rec,re) 
    % parses satellite xyz (# sat row x 3 col matrix) and returns only those
    % above horizon of receiver at xyzRec (row vector of 3 col) 
    % input xyz is matrix of satellite xyz locations (each sat in a row)
    % input xyzRec is row vector of xyz location of GPS receiver
    % input rec is latitude, longitude, and altitude of GPS receiver
    % where altitude of receiver must == 0 in this program
    % input re is radius of spherical earth in meters
    % output is rows of xyz for which satellites are in view of receiver
    
    % get equations of planes that are tangent to spherical earth at 
    % locations surrounding xyzRec to require sat to be some min angle
    % above horison
    % xyzRec(1) * x + xyzRec(2) * y + xyzRec(3) * z = p
    % at xyz = xyzRec, this is eqn for square of distance of xyz from 0,0,0
    % p = sum(xyzRec.^2, 2); % sum option 2 to sum rows 
    
    % look at 4 locations surrounding receiver and require satellite
    % to be visible from all those locations
    degdel = 10.1 % degree change in lat or long around receiver loc 
    xyzDel = zeros([4 3]);
    % change lat by + del
    recDel = rec;
    recDel(1) = recDel(1) + degdel
    [x,y,z] = fLatLongToXYZ(recDel, re);
    xyzDel(1,:) = [x,y,z];
    % change lat by - del
    recDel = rec;
    recDel(1) = recDel(1) - degdel
    [x,y,z] = fLatLongToXYZ(recDel, re);
    xyzDel(2,:) = [x,y,z];
    % change long by + del
    recDel = rec;
    recDel(2) = recDel(2) + degdel
    [x,y,z] = fLatLongToXYZ(recDel, re);
    xyzDel(3,:) = [x,y,z];
    % change long by - del
    recDel = rec;
    recDel(2) = recDel(2) - degdel 
    [x,y,z] = fLatLongToXYZ(recDel, re);
    xyzDel(4,:) = [x,y,z]
    
    p = sum(xyzDel.^2, 2) % sum option 2 to sum rows
    
    % for each satellite xy, determine z of tangent plane and compare to 
    % satellite z
    % for receiver at lat > 0 (North), sat z must be > tangent z
    % for receiver at equator (lat == 0), any z is good
    % for receiver at lat < 0 (South) sat z must be < tangent z 
    
    % compute satellite z on receiver's tangent plane for satellite x,y 
    
    % initialize array for row numbers (needed in case none found)
    rowView = [];
    
    % WARNING: lat of receiver (+/- degdel) == 0 gives z == 0 & division by zero
    % in equation, so add small change of +1 cm to receiver (+/- degdel) z 
    for n = 1:4
        if (xyzDel(n,3) == 0)
            xyzDel(n,3) = 0.01; % local value only, not changed in main
        end
    end
    
    % repeat for each satellite
    [r c] = size(xyz);
    
    for s = 1:r
        
        flag = true; % if stays true then sat is above all planes 
        
        % repeat through tangent planes of 4 locations around receiver
        for n = 1:4 
            % get z of satellite s for this tangent plane n
            zplane = (p(n) - xyzDel(n,1) .* xyz(s,1) - xyzDel(n,2) .* xyz(s,2)) ./ xyzDel(n,3);
            zplane
            xyz(s,3)
            % now want z > zplane for receiver (+/- degdel) in northern hemisphere
            % z < zplane for receiver (+/- degdel) in southern hemisphere 
            if xyzDel(3) > 0
                % receiver (+/- degdel) in Northern hemisphere
                % want satellites whose z > zplane
                if xyz(s,3) < zplane
                    flag = false;
                end
            else
                % receiver (+/- degdel) in Southern hemisphere
                % none at equator at z == 0 because of +1 cm offset added above
                % find satellites whose z < zplane
                if xyz(s,3) > zplane
                    flag = false;
                end
            end
        end % end of repeat for sat s for all 4 horizons

        if (flag == true) 
            % sat s is above 4 horizons
            % append to column list of sat in view
            rowView = [rowView; s];
        end
 
    end % end of repeat through all satellites s
       
    % return row numbers of satellites in view above receiver's horizon
    % return rowView
    
  