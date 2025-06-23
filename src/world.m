classdef world
    properties
        width;
        height;
        generation;
        cells;
        start_generation_at;
        margolus_table = {
            [0, 0; 0, 0],
            [0, 0; 0, 1],
            [0, 0; 1, 0],
            [0, 0; 1, 1],
            [0, 1; 0, 0],
            [0, 1; 0, 1],
            [0, 1; 1, 0],
            [0, 1; 1, 1],
            [1, 0; 0, 0],
            [1, 0; 0, 1],
            [1, 0; 1, 0],
            [1, 0; 1, 1],
            [1, 1; 0, 0],
            [1, 1; 0, 1],
            [1, 1; 1, 0],
            [1, 1; 1, 1]
        };
    endproperties

    methods(Access = "protected")
        function is_valid = _is_valid_size(self, x, name)
            is_valid = false;

            if (!isinteger(x))
                error([name, " must be an integer."])
            endif

            if (x < 1)
                error([name, " must be greater than zero."])
            endif

            if (mod(x, 2) != 0)
                error([name, " must be a multiple of two."])
            endif

            is_valid = true;
        endfunction
    endmethods

    methods
        function this = world(width, height, start_generation_at = uint32(0), world_type = world_preset_type.RANDOM)
            if (this._is_valid_size(width, "Width"))
                this.width = width;
            endif

            if (this._is_valid_size(height, "Height"))
                this.height = height;
            endif

            this.start_generation_at = start_generation_at;
            this.cells = this.get_preset_cells(world_type);
            this.generation = this.start_generation_at;
        endfunction

        function this = reset_world(this, world_type = world_preset_type.RANDOM)
            this.cells = this.get_preset_cells(world_type);
            this = this.reset_generation();
        endfunction

        function this = set_cells(this, new_cells)
            if (ndims(new_cells) != 2)
                error("New world cells must have exactly two dimensions.");
                return;
            endif

            this.width = rows(new_cells);
            this.height = columns(new_cells);
            this.cells = new_cells;
            this = this.reset_generation();
        endfunction

        function this = set_cell(this, x, y, is_alive)
            if (x < 1 | x > columns(this.cells) | y < 1 | y > rows(this.cells))
                error("Cell index is out of range.");
            endif

            this.cells(y, x) = logical(is_alive);
        endfunction

        function this = flip_cell(this, x, y)
            if (x < 1 | x > columns(this.cells) | y < 1 | y > rows(this.cells))
                error("Cell index is out of range.");
            endif

            this = this.set_cell(x, y, ~this.cells(y, x));
        endfunction

        function this = reset_generation(this)
            this.generation = this.start_generation_at;
        endfunction

        function generation_str = generation_str(this)
            generation_str = ["Generation ", int2str(this.generation)];
        endfunction

        function this = clear_cells(this)
            this.cells = this.empty_cells();
        endfunction

        function generation = get_generation(this)
            generation = this.generation;
        endfunction

        function cells = get_cells(this)
            cells = this.cells;
        endfunction

        function cells = get_preset_cells(this, world_type)
            if (world_type == world_preset_type.EMPTY)
                cells = this.empty_cells();
            elseif (world_type == world_preset_type.FILL)
                cells = this.fill_cells();
            else
                cells = this.random_cells();
            endif
        endfunction

        function cells = random_cells(this, probability = 1/3)
            cells = rand(this.height, this.width) < probability;
        endfunction

        function cells = empty_cells(this)
            cells = zeros(this.height, this.width);
        endfunction

        function cells = fill_cells(this)
            cells = ones(this.height, this.width);
        endfunction
    endmethods

    methods(Abstract)
        function this = next_step(this)
        endfunction

        function this = previous_step(this)
        endfunction
    endmethods
endclassdef
