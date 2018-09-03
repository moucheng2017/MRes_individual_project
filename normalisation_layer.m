classdef normalisation_layer < nnet.layer.Layer
    
    properties
        % (Optional) Layer properties
    end

    methods
        function layer = normalisation_layer(name)
            % Consturctor
            % This function must have the same name as the layer
            
            layer.Name = name;
       
            layer.Description = 'This is a custom layer for normalisation to achieve spatial attention';
        
        end
        
        function Z = predict(~, X)
            % Forward input data through the layer at prediction time and
            % output the result
            % 
            % Inputs:
            %         layer    -    Layer to forward propagate through
            %         X        -    Input data
            % Output:
            %         Z        -    Output of layer forward function
            % the first input is fine features
            % the second input is the coarse features
            mean_value=mean2(X);
            Z= X-mean_value;
            Z = Z./Z;
            size_x=size(X);
            if (length(size_x)==3)
            Z = mean(Z,3);
            else
            Z = mean(Z,4);  
            end
        end

        function [dX] = backward(~,X,Z, ~  , ~ )
            % Backward propagate the derivative of the loss function through 
            % the layer
            %
            % Inputs:
            %         layer             - Layer to backward propagate through
            %         X                 - Input data
            %         Z                 - Output of layer forward function            
            %         dLdZ              - Gradient propagated from the deeper layer
            %         memory            - Memory value which can be used in
            %                             backward propagation
            % Output:
            %         dLdX              - Derivative of the loss with respect to the
            %                             input data
            %         dLdW1, ..., dLdWn - Derivatives of the loss with respect to each
            % 
            % 
            dX = Z./(X.*X);
            
 
            % Layer backward function goes here
        end
        
              
    end
end
