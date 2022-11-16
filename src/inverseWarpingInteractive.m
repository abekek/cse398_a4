
% __________________________________________
% Source: Adam Czajka, Toan Q. Nguyen, February 2016
% Modified: AB, October 2020

% load an example image
[filename,path] = uigetfile('*');
I = imread([path filename]);
[rows, cols, ndims] = size(I);

% Show an input image
figure; imshow(I);

% Get four source points
% NOTE: start with upper-left corner and go clockwise (!)
[~,~,~,xSource,ySource] = roipoly();

% I_transformed will contain our resulting image
I_transformed = uint8(zeros(size(I)));

% And we want to have them in the image corners:
xDest =     [1      cols    cols     1];
yDest =     [1      1       rows    rows];

% Let's calculate the projective matrix H:
disp('Calculating the projective matrix H ...')
H = getHmatrix(xSource,ySource,xDest,yDest);

% Having matrix H we may do our transformation for each pixel:
disp('Transforming the pixels ...')
count = 0;
for y_source = 1:rows
    for x_source = 1:cols


        sourcePX = [double(x_source); double(y_source); 1];

        % *** Task1: the following line requires modification if you want to
        % impelment the "inverse warping":
        destPX = inv(H) * sourcePX;

        x_dest = int16(destPX(1)/destPX(3));
        y_dest = int16(destPX(2)/destPX(3));

        if x_dest > 0 && y_dest > 0 && x_dest <= cols && y_dest <= rows
            count = count + 1;
            for n = 1:ndims

                % *** Task1: the following line requires modification if you
                % want to impelment the "inverse warping":
                I_transformed(y_source, x_source, n) = I(y_dest, x_dest, n);

            end
        end

    end
end

% Show the result
figure; imshow(I_transformed);
imwrite(I_transformed, sprintf('output/panorama_3images_%s_cropped_inverse_warping.png', folder_name))

disp(['This version of warping calculated new values for ' num2str(100*count/(rows*cols)) '% of destination pixels.'])
