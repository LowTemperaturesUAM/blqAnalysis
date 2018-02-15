function[x,y] =  puntosRaton()

    [x(1), y(1), button] = ginput(1);
    i=1;
    hold on
    while button ==1
        i = i+1;
        sca.Visible = 'Off';
        [x(i), y(i), button] = ginput(1);
        
        sca = scatter(x,y,70,'Filled','CData',summer(i));
        
    end

scatter(x,y,70,'Filled','CData',summer(i))
hold off
end
