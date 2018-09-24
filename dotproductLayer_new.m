classdef dotproductLayer_new < nnet.layer.Layer
% This is for spatial attention.    
    properties
    end

    methods
        function layer = dotproductLayer_new(name)
            % Consturctor
            % This function must have the same name as the layer
            
            layer.Name = name;

            %layer.dims = d;
            
            %layer.height = h;
            
            %layer.width = w;
       
            layer.Description = 'This is a custom layer for attention mechanism with interpolation';
        
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
            size_x=size(X);
            height=size_x(1);
            width=size_x(2);
            channels=size_x(3);
            half_channels=0.5*channels;
            if (length(size_x)==3)
                X_1 = X(:,:,1:half_channels);
                X_1 = mean(X_1,3);% linear interpolation along third dimensionality to get only spatial weights regardless of channels
                X_2 = X(:,:,half_channels+1:channels);
                Z=X_1.*X_2;
            else
                minibatch_size=size_x(4);
                X_new=reshape(X,height,width,minibatch_size*channels);
                half_channels_minibatch=0.5*minibatch_size*channels;
                X_1 = X_new(:,:,1:half_channels_minibatch);
                X_1 = mean(X_1,3);% linear interpolation along third dimensionality to get only spatial weights regardless of channels
                X_2 = X_new(:,:,half_channels_minibatch+1:minibatch_size*channels);
                Z=X_1.*X_2;
                Z=reshape(Z,height,width,half_channels,minibatch_size);
            end

        end

        function [dX] = backward(~,X,~, dZ , ~ )
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
            size_x=size(X);
            height=size_x(1);
            width=size_x(2);
            channels=size_x(3);
            half_channels=0.5*channels;
            if (length(size_x)==3)
                X_1 = X(:,:,1:half_channels);
                X_2 = X(:,:,half_channels+1:channels);
                dX_1=X_2.*dZ;
                dX_2=mean(X_1,3).*dZ;
                dX=cat(3,dX_1,dX_2);
            else
                minibatch_size=size_x(4);
                X_new=reshape(X,height,width,minibatch_size*channels);
                half_channels_minibatch=0.5*minibatch_size*channels;
                X_1 = X_new(:,:,1:half_channels_minibatch);
                X_2 = X_new(:,:,half_channels_minibatch+1:minibatch_size*channels);
                dZ=reshape(dZ,height,width,0.5*minibatch_size*channels);
                dX_1=X_2.*dZ;
                dX_2=mean(X_1,3).*dZ; 
                dX=cat(3,dX_1,dX_2);
                dX=reshape(dX,height,width ,channels,minibatch_size);
            end

            
            
            % Layer backward function goes here
        end
        
              
    end
end
