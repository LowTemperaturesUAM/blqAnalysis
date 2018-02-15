function [bestImage] = bestImage(FlattenMatrix)
bestImage = FlattenMatrix;
a = histogram(FlattenMatrix,'Visible','off');
Values = [a.Values'/max(a.Values) a.BinEdges(2:end)'];


for i=1:size(Topo,1)
    for j = 1:size(Topo,2)
        if FlattenMatrix(i,j) > Value 
            New(i,j) = 1;
        elseif  FlattenMatrix(i,j) < 0
            New(i,j) = 0;
        end
    end
end


        
