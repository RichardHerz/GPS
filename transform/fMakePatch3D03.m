function fMakePatch3D01(p,c)
    % plots multiple triangle surfaces in p using colors in cs
    
    x = p(1,:);
    y = p(2,:);
    z = p(3,:);

    [row col] = size(p);
    % should be 4 rows and integer multiple of 3 columns    
    np = col/3;
    
    x = p(1,:);
    y = p(2,:);
    z = p(3,:);
    
    for j = 1:np
        X(:,j) = x(3*j-2:3*j);
        Y(:,j) = y(3*j-2:3*j);
        Z(:,j) = z(3*j-2:3*j);
    end
    
    patch(X,Y,Z,c)
    
    
    