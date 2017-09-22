function [template] = encode1(polar_array, nscales,E0)
length = size(polar_array,2)*2*nscales;

template = zeros(size(polar_array,1), length);

length2 = size(polar_array,2);
h = 1:size(polar_array,1);
for k=1:nscales
    
    E1 = E0{k};
    
    %Phase quantisation
    H1 = real(E1) > 0;
    H2 = imag(E1) > 0;
    for i=0:(length2-1)
                
        ja = double(2*nscales*(i));
        %construct the biometric template
        template(h,ja+(2*k)-1) = H1(h, i+1);
        template(h,ja+(2*k)) = H2(h,i+1);
        
    end
    
end 