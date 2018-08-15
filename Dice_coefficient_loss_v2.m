classdef Dice_coefficient_loss_v2 < nnet.layer.ClassificationLayer

    methods
        function layer = Dice_coefficient_loss_v2(name)           
            % (Optional) Create a myClassificationLayer
            
            % Set layer name
            if nargin == 1
                layer.Name = name;
            end

            % Set layer description
            layer.Description = 'Dice coefficient layer version2 for semantic segmentation';
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
            Y=nnet.internal.cnn.util.boundAwayFromZero(Y);
            smooth=1;
           
            pred_scores=Y;
            true_scores=T;
            truth_pred_multiplication=pred_scores.*true_scores;
            t_square=true_scores.^2;
            p_square=pred_scores.^2;
            sum_t_p_multi=sum(sum(sum(sum(truth_pred_multiplication,3),2),1));
            sum_t_square=sum(sum(sum(sum(t_square,3),2),1));
            sum_p_square=sum(sum(sum(sum(p_square,3),2),1));
            %{
            for i=1:1:minibatch
            pred_scores=Y(:,:,i);
            true_scores=T(:,:,i);
            
            truth_pred_multiplication=pred_scores.*true_scores;
            t_square=true_scores.^2;
            p_square=pred_scores.^2;
            sum_t_p_multi_temp=sum(sum(truth_pred_multiplication,2),1);
            sum_t_square_temp=sum(sum(t_square,2),1);
            sum_p_square_temp=sum(sum(p_square,2),1);
            if i ==1
                sum_t_p_multi=sum_t_p_multi_temp;
                sum_t_square=sum_t_square_temp;
                sum_p_square=sum_p_square_temp;
            else
                sum_t_p_multi=sum_t_p_multi_temp+sum_t_p_multi;
                sum_t_square=sum_t_square_temp+sum_t_square;
                sum_p_square=sum_p_square_temp+sum_p_square;                
            end
            end
            %}
            dice_numerator=2*sum_t_p_multi;
            dice_denominator=sum_t_square+sum_p_square;
            dice_coe=(dice_numerator+smooth)/(dice_denominator+smooth);
            loss=-dice_coe;
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
            Y=nnet.internal.cnn.util.boundAwayFromZero(Y);
            
            pred_scores=Y;
            true_scores=T;
            truth_pred_multiplication=pred_scores.*true_scores;
            t_square=true_scores.^2;
            p_square=pred_scores.^2;
            sum_t_p_multi=sum(sum(sum(sum(truth_pred_multiplication,3),2),1));
            sum_t_square=sum(sum(sum(sum(t_square,3),2),1));
            sum_p_square=sum(sum(sum(sum(p_square,3),2),1));            
            %{
            for i=1:1:minibatch
            pred_scores=Y(:,:,i);
            true_scores=T(:,:,i);
            
            truth_pred_multiplication=pred_scores.*true_scores;
            t_square=true_scores.^2;
            p_square=pred_scores.^2;
            sum_t_p_multi_temp=sum(sum(truth_pred_multiplication,2),1);
            sum_t_square_temp=sum(sum(t_square,2),1);
            sum_p_square_temp=sum(sum(p_square,2),1);
            if i ==1
                sum_t_p_multi=sum_t_p_multi_temp;
                sum_t_square=sum_t_square_temp;
                sum_p_square=sum_p_square_temp;
            else
                sum_t_p_multi=sum_t_p_multi_temp+sum_t_p_multi;
                sum_t_square=sum_t_square_temp+sum_t_square;
                sum_p_square=sum_p_square_temp+sum_p_square;                
            end
            end
            %}
            gradient_numerator=(sum_t_square+sum_p_square)*T-2*sum_t_p_multi*Y;
            gradient_denominator=(sum_t_square+sum_p_square)^2;
            dLdY=-2*(gradient_numerator/gradient_denominator);
            %dLdY=1*dLdY;
        end
    end

end