function eh = getEOHDescriptors(keypoint, image, window_size) 
    %conf
    vent = window_size;
    num_keypoint=size(keypoint);
    tam_imagen=size(image);
    fil=tam_imagen(1,1);
    col=tam_imagen(1,2);
    x = keypoint(1,:);
    y = keypoint(2,:);
    eh = zeros(80, num_keypoint(1,2));
    
    %Get descriptor for each keypoint
    parfor i=1:num_keypoint(1,2)
        y1=max(1, x(i)-vent) ;  
        y1=min(col,y1); 
        y2=min(col, x(i)+vent);

        x1=max(1, y(i)-vent);
        x1=min(fil,x1);   
        x2=min(fil, y(i)+vent);

        if y1==y2 
            continue;
        end
        if x1==x2 
            continue;
        end    
        
        %patch
        img=image(x1:x2,y1:y2); 
        %get descriptor
        [eh1]=eoh(img,[],3,0);  
        eh(:,i)= eh1;
    end
end