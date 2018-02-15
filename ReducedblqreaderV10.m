function  [Voltaje, IdaIda, IdaVuelta,VueltaIda,VueltaVuelta] = ReducedblqreaderV10( FileName , Filas, Columnas, Eleccion)

FileID = fopen (FileName,'r');
%EstructuraDatos(4*Filas*Columnas+1) = struct();
    fprintf('COPIANDO DATOS:');
% ------------------------------------------
% Las matrices de salida son:
%     Voltaje      = zeros(IV,1);
%     IdaIda       = zeros(IV,Filas*Columnas);
%     IdaVuelta    = zeros(IV,Filas*Columnas);
%     VueltaIda    = zeros(IV,Filas*Columnas);
%     VueltaVuelta = zeros(IV,Filas*Columnas);
%     display([IV,Filas*Columnas]);
%     display(size(VueltaIda));

    ColII = 0;
    ColIV = 0;
    ColVI = 0;
    ColVV = 0;

IdaIda       = 0;
IdaVuelta    = 0;
VueltaIda    = 0;
VueltaVuelta = 0;

for NumeroCurva = 1 : 1 : 4*Filas*Columnas

    %cabecera 400 bytes Solo Leo lo absolutamente necesario.
    
    fread (FileID, 4, 'uint16'); % No nos interesa pero, ¿qué es?          
    Control = fread (FileID, 32,'uchar'); % En realidad contiene el nombre del fichero, cuando no está, está vacío
    
    if isempty(Control) % Cuando los 32 bits de hname están vacíos (no hay más datos) deja de leer.
      
        break; 
    end
    
    TamanoDatos = fread (FileID, 2, 'int32'); 
        NumeroFilas    = TamanoDatos(2);
        
    fread(FileID,352,'uchar'); % No nos interesa leerlo, ¿qué es?
    
    if NumeroCurva == 1 % Diferenciamos el caso para cargar el voltaje
      
        % --------------------------------------
        TamanhoDatos =  fread(FileID, 2, 'uint16'); % Nos da el formato de los datos
            DataFormat =  TamanhoDatos(2);
        
        fread(FileID, 2, 'int32'); % No nos interesa leerlo, ¿qué es?
            
        hofss      =  fread (FileID, 4, 'float64');
            Offset     =  hofss(1);
            Factor     =  hofss(2); % este valor es un float64, al multiplicarlo, todos los datos serán float... hay que sacarlo de aquí      
            Start      =  hofss(3); 
            Size       =  hofss(4);
            
        fread(FileID,84,'uchar'); % No nos interesa leerlo, ¿qué es?  

        switch DataFormat
        	case 0
            	Data = Factor*(Offset + Start + (Size/NumeroFilas)*(0:(NumeroFilas-1)));   
                Data = Data';
            case 1
                Data = Factor*(fread (FileID, NumeroFilas, 'int8'));
                display('int8');
            case 2
                Data = Factor*(fread (FileID, NumeroFilas, 'int16'));
                display('int16');
            case 4
                Data = Factor*(fread (FileID, NumeroFilas, 'float32'));
                display('float32');
            case 8 
                Data = Factor*(fread (FileID, NumeroFilas, 'float64'));
                display('float64');
            otherwise
                display('Wrong data format!');
        end
       
        %EstructuraDatos(NumeroCurva).data  = Data; % El voltaje va en la primera curva
            IV =  length(Data);
            Voltaje = zeros(IV,1);

            if Eleccion(1)
%                 IV
%                 Filas
%                 Columnas
                IdaIda       = zeros(IV,Filas*Columnas);
            end

            if Eleccion(2)
                IdaVuelta    = zeros(IV,Filas*Columnas);
            end

            if Eleccion(3)
%                 263263
                VueltaIda    = zeros(IV,Filas*Columnas);
            end

            if Eleccion(4)
                VueltaVuelta = zeros(IV,Filas*Columnas);
            end

            display([IV,Filas*Columnas]);
            %display(size(VueltaIda));
            Voltaje(:,1) = Data;
        
        % --------------------------------------
        
        % Leemos de nuevo para cargar la correspondiente corriente
        % ---------------------------------------
        TamanhoDatos =  fread(FileID, 2, 'uint16'); % Nos da el formato de los datos
            DataFormat =  TamanhoDatos(2);
        
        fread(FileID, 2, 'int32'); % No nos interesa leerlo, ¿qué es?
            
        hofss      =  fread (FileID, 4, 'float64');
            Offset =  hofss(1);
            Factor =  hofss(2); % este valor es un float64, al multiplicarlo, todos los datos serán float... hay que sacarlo de aquí      
            Start  =  hofss(3); 
            Size   =  hofss(4);
            
        fread(FileID,84,'uchar'); % No nos interesa leerlo, ¿qué es?    
       

        
        switch DataFormat
        	case 0
            	Data = Factor*(Offset + Start + (Size/NumeroFilas)*(0:(NumeroFilas-1)));   
                Data = Data';
            case 1
                Data = Factor*(fread (FileID, NumeroFilas, 'int8')); 
                display('int8');
            case 2
                Data = Factor*(fread (FileID, NumeroFilas, 'int16'));
                display('int16');
            case 4
                Data = Factor*(fread (FileID, NumeroFilas, 'float32'));  
                display('float32');
            case 8 
                Data = Factor*(fread (FileID, NumeroFilas, 'float64'));
                display('float64');
            otherwise
                display('Wrong data format!');
        end
        
       % EstructuraDatos(NumeroCurva+1).data  = Data; % Cargamos la primera corriente

        if Eleccion(1) == 1
            ColII = ColII+1;
            IdaIda(:,ColII) = Data;

%         elseif Eleccion(2) == 1;
%             ColIV = ColIV + 1;
%             IdaVuelta(:,ColIV) = Data;
% 
%         elseif Eleccion(3) == 1;
%             ColVI = ColVI + 1;
%             VueltaIda(:,ColVI) = Data;
% 
%         elseif Eleccion(4) == 1;
%             ColVV = ColVV + 1;
%             VueltaVuelta(:,ColVV) = Data;
        end

        
    else
        
        % Ahora cargaremos solamente las corrientes, por lo que tenemos que
        % saltarnos en voltaje en cada curva:
        % ----------------------------------------
        TamanhoDatos =  fread(FileID, 2, 'uint16'); % Nos da el formato de los datos
            DataFormat =  TamanhoDatos(2);
        
        fread(FileID, 2, 'int32'); % No nos interesa leerlo, ¿qué es?
            
        
        hofss =  fread (FileID, 4, 'float64');
            Offset =  hofss(1);
%             Factor =  hofss(2); % este valor es un float64, al multiplicarlo, todos los datos serán float... hay que sacarlo de aquí      
            Start  =  hofss(3); 
            Size   =  hofss(4);
            
        fread(FileID,84,'uchar'); % No nos interesa leerlo, ¿qué es?    
              

        
        switch DataFormat
        	case 0
            	Data = Factor*(Offset + Start + (Size/NumeroFilas)*(0:(NumeroFilas-1)));   
                Data = Data';
            case 1
                fread (FileID, NumeroFilas, 'int8');       
            case 2
                fread (FileID, NumeroFilas, 'int16');
            case 4
                fread (FileID, NumeroFilas, 'float32');        
            case 8 
                fread (FileID, NumeroFilas, 'float64');
            otherwise
                display('Wrong data format!');
        end
        % ----------------------------------------
  
        % Leemos de nuevo para cargar la correspondiente corriente.
        %
        % Obviando los voltajes de cada curva dejamos de cargar en memoria
        % Filas x Columnas x IV x 4 puntos, que en tamaño double e imágenes
        % grandes puede suponer más de 1 GB de memoria que, aunque luego
        % borremos, hay que tener en memoria para copiar datos. Además el
        % tiempo de carga se reduce casi a la mitad.
        
        % ---------------------------------------
        TamanhoDatos =  fread(FileID, 2, 'uint16'); % Nos da el formato de los datos
            DataFormat =  TamanhoDatos(2);
        
        fread(FileID, 2, 'int32'); % No nos interesa leerlo, ¿qué es?
            
        hofss      =  fread (FileID, 4, 'float64');
            Offset     =  hofss(1);
            Factor     =  hofss(2); % este valor es un float64, al multiplicarlo, todos los datos serán float... hay que sacarlo de aquí      
            Start      =  hofss(3); 
            Size       =  hofss(4);
            
        fread(FileID,84,'uchar'); % No nos interesa leerlo, ¿qué es?    
              

        
        switch DataFormat
        	case 0
            	Data = Factor*(Offset + Start + (Size/NumeroFilas)*(0:(NumeroFilas-1)));   
                Data = Data';
            case 1
                Data = Factor*(fread (FileID, NumeroFilas, 'int8'));       
            case 2
                Data = Factor*(fread (FileID, NumeroFilas, 'int16'));
            case 4
                Data = Factor*(fread (FileID, NumeroFilas, 'float32'));        
            case 8 
                Data = Factor*(fread (FileID, NumeroFilas, 'float64'));
            otherwise
                display('Wrong data format!');
        end
        
        %EstructuraDatos(NumeroCurva+1).data  = Data; % Guardamos solo la corriente
 
        if mod(floor((NumeroCurva+1)/(2*Columnas)),2) == 0
            if mod(NumeroCurva+1,2) == 0 && Eleccion(1) == 1    
                ColII = ColII + 1;
                
                IdaIda(:,ColII) = Data;
            else
                if mod(NumeroCurva+1,2) ~= 0 && Eleccion(2) == 1
                    ColIV = ColIV + 1;
                   
                    IdaVuelta(:,ColIV) = Data;
                end
            end
        else
            if mod(NumeroCurva+1,2) == 0 && Eleccion(3) == 1
                ColVI = ColVI + 1;
               
                VueltaIda(:,ColVI) = Data;
            else
                if mod(NumeroCurva+1,2) ~= 0 && Eleccion(4) == 1
                    ColVV = ColVV + 1;
                   
                    VueltaVuelta(:,ColVV) = Data;
                end
            end
        end
    end
end
disp(['Numeros = ', num2str([ColII,ColIV,ColVI,ColVV])]);

if Eleccion(3) ==1 && Eleccion(4) == 1
    VueltaIdaAUX = VueltaIda;
    VueltaVueltaAUX = VueltaVuelta;
    
    for i = 1:Columnas
        VueltaIdaAUX(:,i:Columnas:end-(Columnas-i)) = VueltaIda(:,Columnas-(i-1):Columnas:end-(i-1));
        VueltaVueltaAUX(:,i:Columnas:end-(Columnas-i)) = VueltaVuelta(:,Columnas-(i-1):Columnas:end-(i-1));
    end
        VueltaIda = VueltaIdaAUX;
        clear VueltaIdaAUX;
        VueltaVuelta = VueltaVueltaAUX;
        clear VueltaVueltaAUX;
else
    if Eleccion(4) ==1
        VueltaVueltaAUX = VueltaVuelta;
        display('holaAUX');
        
        for i = 1:Columnas
            VueltaVueltaAUX(:,i:Columnas:end-(Columnas-i)) = VueltaVuelta(:,Columnas-(i-1):Columnas:end-(i-1));
        end
        VueltaVuelta = VueltaVueltaAUX;
        clear VueltaVueltaAUX;
        
    elseif Eleccion(3) == 1
         VueltaIdaAUX = VueltaIda;
         
         for i = 1:Columnas
            VueltaIdaAUX(:,i:Columnas:end-(Columnas-i)) = VueltaIda(:,Columnas-(i-1):Columnas:end-(i-1));
         end
         VueltaIda = VueltaIdaAUX;
        clear VueltaIdaAUX;
    
    end
    

end

    if Eleccion(2) == 1    
        IdaVuelta = flipud(IdaVuelta);
    end
    if Eleccion(4) == 1
        VueltaVuelta = flipud(VueltaVuelta);
        display('holaFLIP');
    end

fclose(FileID);