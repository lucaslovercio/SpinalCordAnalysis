function mask = functionLabelizarPixelPolar( interfacePolar )
%FUNCTIONLABELIZARPIXELPOLAR Summary of this function goes here
%   Detailed explanation goes here

%Crear mascaras

[m,n] = size(interfacePolar);
mask = false(m,n);
for i = 1:1:n
    r = find(interfacePolar(:,i));
    %mask(1:r,i) = 1;
    mask(1:r,i) = 1; %all snakes points inside the mask. 2 px errors max
end

end

