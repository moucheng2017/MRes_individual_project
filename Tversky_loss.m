classdef Tversky_loss < nnet.layer.ClassificationLayer

    methods
        function layer = Tversky_loss(name)           
            % (Optional) Create a myClassificationLayer
            
            % Set layer name
            if nargin == 1
                layer.Name = name;
            end

            % Set layer description
            layer.Description = 'Tversky_loss layer for semantic segmentation';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % Return the loss between the predictions Y and the 
            % training targets T
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         loss  - Loss between Y and T

            % Layer forward loss function goes here
            a=0.3;
            b=0.7;
            numObservations = size(Y, 4) * size(Y, 1) * size(Y, 2);

            p0=Y;
            p1=-1*Y+1;
            g0=T;
            g1=-1*T+1;
            
            p0_g0=p0.*g0;
            p0_g1=p0.*g1;
            p1_g0=p1.*g0;
            
            sum_p0_g0=sum(sum(sum(sum(p0_g0,3),2),1));
            sum_p0_g1=sum(sum(sum(sum(p0_g1,3),2),1));
            sum_p1_g0=sum(sum(sum(sum(p1_g0,3),2),1));

            tversky_numerator=sum_p0_g0;
            tversky_denominator=sum_p0_g0+a*(sum_p0_g1)+b*(sum_p1_g0);
            tversky_coe=(tversky_numerator)/(tversky_denominator);
            loss=1-tversky_coe;
        end
        
        function dLdY = backwardLoss(layer, Y, T)
            % Backward propagate the derivative of the loss function
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the predictions Y

            % Layer backward loss function goes here
            a=0.3;
            b=0.7;            
            p0=Y;
            p1=-1*Y+1;
            g0=T;
            g1=-1*T+1;
            
            p0_g0=p0.*g0;
            p0_g1=p0.*g1;
            p1_g0=p1.*g0;
            
            sum_p0_g0=sum(sum(sum(sum(p0_g0,3),2),1));
            sum_p0_g1=sum(sum(sum(sum(p0_g1,3),2),1));
            sum_p1_g0=sum(sum(sum(sum(p1_g0,3),2),1));
             
            gradient_numerator=(sum_p0_g0+a*(sum_p0_g1)+b*(sum_p1_g0))*T-sum_p0_g0*(T+a*(1-T));
            gradient_denominator=(sum_p0_g0+a*(sum_p0_g1)+b*(sum_p1_g0))^2;
            dLdY=-2*(gradient_numerator/gradient_denominator);
            
        end
    end

end