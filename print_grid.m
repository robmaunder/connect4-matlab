function print_grid(grid)

fprintf('\n');
for row=1:size(grid,1)
    for column=1:size(grid,2)
        fprintf('|');
        if grid(row,column)>0
            fprintf("%d",grid(row,column));
        else
            fprintf(' ');
        end
    end
    fprintf('|\n');
end
fprintf('\n');

