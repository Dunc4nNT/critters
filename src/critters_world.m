classdef critters_world < world
    methods
        function this = critters_world(width, height, start_generation_at = uint32(0), world_type = world_preset_type.RANDOM)
            this@world(width, height, start_generation_at, world_type);
        endfunction

        function this = next_step(this)
            if (mod(this.generation, 2) == 0)
                offset = 0;
            else
                offset = 1;
            endif

            % TODO: make this not use for loops...
            for row = 1:2:(rows(this.cells))
                for col = 1:2:(columns(this.cells))
                    x = row + offset;
                    y = col + offset;

                    if (x > rows(this.cells))
                        x = mod(x, rows(this.cells));
                    endif

                    if (y > columns(this.cells))
                        y = mod(y, columns(this.cells));
                    endif

                    x2 = x + 1;
                    y2 = y + 1;

                    if (x2 > rows(this.cells))
                        x2 = mod(x2, rows(this.cells));
                    endif

                    if (y2 > columns(this.cells))
                        y2 = mod(y2, columns(this.cells));
                    endif

                    block = [
                        this.cells(x, y), this.cells(x, y2);
                        this.cells(x2, y), this.cells(x2, y2)
                    ];

                    alive = sum(sum(block));

                    if (alive != 2)
                        block = ~block;
                    endif

                    if (alive == 3)
                        block = flipud(block);
                    endif

                    this.cells(x, y) = block(1, 1);
                    this.cells(x, y2) = block(1, 2);
                    this.cells(x2, y) = block(2, 1);
                    this.cells(x2, y2) = block(2, 2);
                endfor
            endfor

            % if (mod(this.generation, 2) == 0)
            %     selected_cells = this.cells;
            % else
            %     selected_cells = this.cells([end 1:end 1], [end 1:end 1]);
            % endif

            % neighbours = conv2(selected_cells, ones(2), "valid");

            this.generation++;
        endfunction

        function this = previous_step(this)
            error("previous_step is not implemented.")
        endfunction
    endmethods
endclassdef
