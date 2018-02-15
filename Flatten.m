%% Function for flatten a matrix
 %Inputs.- Matrix: Matrix to flatten
 %         flag  : 2-Vector to choose the direcction of flatten 
 %                 [1 0]- Only Rows
 %                 [0 1]- Only Columns
 %                 [1 1]- Rows & Columns


function [FlattenMatrix] = Flatten(Matrix, flag)
    
    mediaTotal = mean(mean(Matrix));    %Average of all points

    FlattenMatrix = Matrix ;             %New matrix define to ble flattened
    if flag(1)
        %
        for i = 1:length(Matrix(:,1))
           FlattenMatrix(i,:) = Matrix(i,:) - (mean(Matrix(i,:)) - mediaTotal);
        end
        
    end
    
    if flag(2)
        if ~flag(1); FlattenMatrix = Matrix;end
        
            for i = 1:length(Matrix(1,:))
               FlattenMatrix(:,i) = FlattenMatrix(:,i) - (mean(FlattenMatrix(:,i)) - mediaTotal);
            end
    end
    
    if min(min(FlattenMatrix))<0; FlattenMatrix = FlattenMatrix - min(min(FlattenMatrix)) - 0.1*min(min(FlattenMatrix)) ; end
    

end
