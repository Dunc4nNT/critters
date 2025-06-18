clear all;
close all;

ROWS = uint32(100);
COLS = uint32(200);
START_GENERATION_AT = uint32(0);

screensize = get(0.0, "screensize")(3:4);
[data.SCREEN_WIDTH, data.SCREEN_HEIGHT] = num2cell(screensize){:};
clear screensize;

function simulate(world_width, world_height, start_generation_at)
    data.world = game_of_life_world(world_width, world_height, start_generation_at);
    data.world.get_generation()
    data.world.next_step();
    data.world.get_generation()
    data.world.reset_generation();
    data.world.get_generation()
endfunction

simulate(ROWS, COLS, START_GENERATION_AT);
