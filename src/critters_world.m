classdef critters_world < world
    properties
        rule = [16, 15, 14, 4, 12, 6, 7, 2, 8, 10, 11, 3, 13, 5, 9, 1];
    endproperties

    methods
        function this = critters_world(width, height, start_generation_at = uint32(0), world_type = world_preset_type.RANDOM)
            this@world(width, height, start_generation_at, world_type);
        endfunction

        function this = next_step(this)
            if (mod(this.generation, 2) == 0)
                select_cells = ~this.cells;
            else
                select_cells = this.cells([end 1:end 1], [end 1:end 1]);
            endif

            created_cells = select_cells([1:2:end], [1:2:end]) .* 8 + select_cells([1:2:end], [2:2:end]) .* 4 + select_cells([2:2:end], [1:2:end]) .* 2 + select_cells([2:2:end], [2:2:end]) .* 1 + 1;

            if (mod(this.generation, 2) == 0)
                this.cells = cell2mat(this.margolus_table(this.rule(created_cells)));
            else
                this.cells = ~cell2mat(this.margolus_table(this.rule(created_cells)))([2:end-1], [2:end-1]);
            endif

            this.generation++;
        endfunction

        function this = previous_step(this)
            error("previous_step is not implemented.")
        endfunction
    endmethods
endclassdef
