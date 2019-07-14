function fPlotTriangles3D(p,c)
    % plot multiple triangle surfaces in p using colors in c
    %
    % this function is specific to input matrix p containing separate
    % copies of triangles for each face of an object
    % 
    % write a different function when input matrix contains only
    % a single copy of each vertex of an object and 
    % use the form: patch('Faces',f,'Vertices',v,'FaceColor',c) 
    
    x = p(1,:); 
    y = p(2,:); 
    z = p(3,:);

    [row col] = size(p);
    % should be integer multiple of 3 columns for triangles  
    np = col/3;
 
    for j = 1:np
        X(:,j) = x(3*j-2:3*j);
        Y(:,j) = y(3*j-2:3*j);
        Z(:,j) = z(3*j-2:3*j);
    end
    
    patch(X,Y,Z,c)