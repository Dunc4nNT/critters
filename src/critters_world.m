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

            % TODO: fix the indexing issue, it's missing some corner cells
            % TODO: make this not use for loops...
            for row = 1:2:(rows(this.cells) - 2)
                for col = 1:2:(columns(this.cells) - 2)
                    x = row + offset;
                    y = col + offset;

                    block = [
                        this.cells(x, y), this.cells(x, y + 1);
                        this.cells(x + 1, y), this.cells(x + 1, y + 1)
                    ];

                    alive = sum(sum(block));

                    if (alive != 2)
                        block = ~block;
                    endif

                    if (alive == 3)
                        block = flipud(block);
                    endif

                    this.cells(x, y) = block(1, 1);
                    this.cells(x, y + 1) = block(1, 2);
                    this.cells(x + 1, y) = block(2, 1);
                    this.cells(x + 1, y + 1) = block(2, 2);
                endfor
            endfor

            this.generation++;
        endfunction

        function this = previous_step(this)
            error("previous_step is not implemented.")
        endfunction
    endmethods
endclassdef
