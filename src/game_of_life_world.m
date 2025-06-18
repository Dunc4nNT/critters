classdef game_of_life_world < world
    methods
        function this = game_of_life_world(width, height, start_generation_at = uint32(0), world_type = world_preset_type.RANDOM)
            this@world(width, height, start_generation_at, world_type);
        endfunction

        function this = next_step(this)
            neighbours = conv2(this.cells([end 1:end 1], [end 1:end 1]), ones(3), "valid");

            this.cells = (neighbours == 3) | (neighbours - this.cells == 3);
            this.generation++;
        endfunction

        function this = previous_step(this)
            error("previous_step is not implemented.")
        endfunction
    endmethods
endclassdef
