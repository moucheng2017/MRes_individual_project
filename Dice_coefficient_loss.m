classdef Dice_coefficient_loss < nnet.layer.ClassificationLayer

    methods
        function layer = Dice_coefficient_loss(name)           
            % (Optional) Create a myClassificationLayer
            
            % Set layer name
            if nargin == 1
                layer.Name = name;
            end

            % Set layer description
            layer.Description = 'Dice coefficient layer for semantic segmentation';
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
            %{
            for j=1:4
                for k=1:224
                    for m=1:224
                        if (T(k,m,j)==1)
                            T(k,m,j)=1;
                        else
                            T(k,m,j)=0;
                        end
                    end
                end
            end
            %}
            numObservations = size(Y, 4) * size(Y, 1) * size(Y, 2);
            smooth=1;
            minibatch=size(Y, 4);
            
            for i=1:1:minibatch
            pred_scores=Y(:,:,i);
            true_scores=T(:,:,i);
            sum_scores=pred_scores+true_scores;
            
            truth_pred_multiplication=pred_scores.*true_scores;
            %t_square=true_scores.^2;
            %p_square=pred_scores.^2;
            sum_t_p_multi_temp=sum(sum(truth_pred_multiplication,2),1);
            sum_t_p_temp=sum(sum(sum_scores,2),1);
            %sum_t_square_temp=sum(sum(t_square,2),1);
            %sum_p_square_temp=sum(sum(p_square,2),1);
            if i ==1
                sum_t_p_multi=sum_t_p_multi_temp;
                sum_t_p=sum_t_p_temp;
                %sum_t_square=sum_t_square_temp;
                %sum_p_square=sum_p_square_temp;
            else
                sum_t_p_multi=sum_t_p_multi_temp+sum_t_p_multi;
                sum_t_p=sum_t_p+sum_t_p_temp;
                %sum_t_square=sum_t_square_temp+sum_t_square;
                %sum_p_square=sum_p_square_temp+sum_p_square;                
            end
            end
            sum_t_p=sum_t_p/numObservations;
            sum_t_p_multi=sum_t_p_multi/numObservations;
            %{
            pred_scores=Y(:,:,3);
            true_scores=T(:,:,3);
            truth_pred_multiplication=pred_scores.*true_scores;
            t_square=true_scores.^2;
            p_square=pred_scores.^2;
            sum_t_p_multi=sum(sum(truth_pred_multiplication,2),1);
            sum_t_square=sum(sum(t_square,2),1);
            sum_p_square=sum(sum(p_square,2),1);
            %}
            dice_numerator=2*sum_t_p_multi;
            dice_denominator=sum_t_p;
            dice_coe=(dice_numerator+smooth)/(dice_denominator+smooth);
            loss=1-dice_coe;
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
            numObservations = size(Y, 4) * size(Y, 1) * size(Y, 2);
            minibatch=size(Y, 4);
            for i=1:1:minibatch
            pred_scores=Y(:,:,i);
            true_scores=T(:,:,i);
            sum_scores=pred_scores+true_scores;
            
            truth_pred_multiplication=pred_scores.*true_scores;

            sum_t_p_multi_temp=sum(sum(truth_pred_multiplication,2),1);
            sum_t_p_temp=sum(sum(sum_scores,2),1);

            if i ==1
                sum_t_p_multi=sum_t_p_multi_temp;
                sum_t_p=sum_t_p_temp;

            else
                sum_t_p_multi=sum_t_p_multi_temp+sum_t_p_multi;
                sum_t_p=sum_t_p+sum_t_p_temp;
                
            end
            end
            sum_t_p=sum_t_p/numObservations;
            sum_t_p_multi=sum_t_p_multi/numObservations;
            
            gradient_numerator=(sum_t_p)*T-sum_t_p_multi;
            gradient_denominator=(sum_t_p)^2;
            dLdY=-2*(gradient_numerator/gradient_denominator);
            %dLdY=1*dLdY;
        end
    end

end