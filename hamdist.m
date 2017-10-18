
function hd = hamdist(template1, template2, scales)

template1 = logical(template1);

template2 = logical(template2);

hd = NaN;

% shift template left and right, use the lowest Hamming distance
for shifts=-8:8
    
    template1s = shiftbits(template1, shifts,scales);
    
    totalbits = (size(template1s,1)*size(template1s,2));
    
    C = xor(template1s,template2);
    
    bitsdiff = sum(sum(C==1));
    
    if totalbits == 0
        
        hd = NaN;
        
    else
        
        hd1 = bitsdiff / totalbits;
        
        
        if  hd1 < hd || isnan(hd)
            
            hd = hd1;
            
        end
        
        
    end
    
end