function point_matrix = n_view_matching(points, features, ima, MaxRatio, Metric)
% n_view_matching Computes point matches along N views. Obtains consistent point correspondences among all images
% HINT: For optimum results, the images should be ordered for a camera moving in a single direction

% Inputs:
% points: cell structure with point locations in all images
% features: cell structure with point descriptors in all images
% ima: cell structure with images (only to visualize results)
% MaxRatio, Metric: Matching parameters

% Output:
% point_matrix: Point correspondences (non-hom coordinates) allong all views (in the same format of the lab sessions of Unit III) 


    numImages = length(points);

    for j = 2:numImages
        indexPairs       = matchFeatures(features{j-1},features{j},'MaxRatio',MaxRatio,'Metric',Metric) ;

        matchedPointsK{j-1,j} =   points{j-1}(indexPairs(:,1));
        matchedPointsK{j,j-1} =   points{j}(indexPairs(:,2));

        for i = 1 : j-1 
            points{i}        = points{i}(indexPairs(:,1));
            features{i}      = features{i}(indexPairs(:,1),:);
        end

        points{j}        = points{j}(indexPairs(:,2));
        features{j}      = features{j}(indexPairs(:,2),:);

    end

    % initialization of point matrix structure
    point_matrix = zeros(2,points{1}.Count,numImages);

    for j = 1:numImages

        point_matrix(:,:,j) = points{j}.Location';

        % show detections
        figure(j)
        imshow(ima{j}); hold on;
        scatter(point_matrix(1,:,j),(point_matrix(2,:,j)))
        % pause
        plot(points{j});
        % pause

    end

end