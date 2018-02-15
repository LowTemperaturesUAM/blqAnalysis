function Out = drawShape(shape,XCenter, YCenter, XRadio, YRadio)

if strcmp(shape, 'circle')
    Out = rectangle('Position',[XCenter - XRadio, YCenter - YRadio, 2*XRadio, 2*YRadio],...
        'Curvature', [1 1], 'FaceColor','red');
elseif strcmp(shape, 'rectangle')
        Out = rectangle('Position',[XCenter - XRadio, YCenter - YRadio, 2*XRadio, 2*YRadio],...
        'Curvature', [0 0], 'FaceColor','red');
end

%Hasta luego PEPE