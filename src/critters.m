clear all;
close all;

ROWS = 100;
COLS = 200;
START_GENERATION_AT = 0;

screensize = get(0.0, "screensize")(3:4);
[data.SCREEN_WIDTH, data.SCREEN_HEIGHT] = num2cell(screensize){:};
clear screensize;

% classdef world_reset_type
%     properties (Constant = true)
%         RANDOM = 0;
%     endproperties
% endclassdef

% classdef world
%     properties
%         width;
%         height;
%         generation;
%         cells;
%         start_generation_at;
%     endproperties

%     methods
%         function world = world(width, height, start_generation_at = 0)
%             if (world._is_valid_size(width, "Width"))
%                 world.width = width;
%             endif

%             if (world._is_valid_size(height, "Height"))
%                 world.height = height;
%             endif

%             world.start_generation_at = start_generation_at
%         endfunction

%         function reset_world(reset_type = world_reset_type.RANDOM)
%             world.reset_cells(reset_type);
%             world.reset_generation();
%         endfunction

%         function reset_generation()
%             world.generation = world.start_generation_at;
%         endfunction

%         function reset_cells(reset_type)
%             if (reset_type == world_reset_type.RANDOM)
%                 world.cells = random_cells();
%             endif
%         endfunction

%         function cells = random_cells() 
%             cells = rand(world.width, world.height) < 1/3;
%         endfunction

%         function is_valid = _is_valid_size(x, name)
%             is_valid = false;

%             if (!isinteger(x))
%                 error([name, " must be an integer."])
%             endif

%             if (x < 1)
%                 error([name, " must be greater than zero."])
%             endif

%             if (mod(x, 2) != 0)
%                 error([name, " must be a multiple of two."])
%             endif

%             is_valid = true;
%         endfunction
%     endmethods
% endclassdef

% function simulate()
%     data.world = world(ROWS, COLS, START_GENERATION_AT);
% endfunction

% simulate()
