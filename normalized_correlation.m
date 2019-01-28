function result = normalized_correlation(image, template)
 
[image_rows, image_columns] = size( image);
[template_rows, template_columns] = size(template);
row_start = floor(template_rows / 2) + 1;
row_end = row_start + image_rows - 1;
col_start = floor(template_columns / 2) + 1;
col_end = col_start + image_columns - 1;
 
result = normxcorr2(template, image);
[result_rows, result_columns] = size(result);
result(1:template_rows, :) = 0;
result((result_rows-template_rows+1):result_rows, :) = 0;
result(:, 1:template_columns) = 0;
result(:, (result_columns-template_columns+1):result_rows, :) = 0;
 
 
result = result(row_start:row_end, col_start:col_end);