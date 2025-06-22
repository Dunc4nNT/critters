clear all;
close all;

ROWS = uint32(100);
COLS = uint32(150);
START_GENERATION_AT = uint32(0);

screensize = get(0.0, "screensize")(3:4);
[SCREEN_WIDTH, SCREEN_HEIGHT] = num2cell(screensize){:};
clear screensize;

function init(world_width, world_height, start_generation_at, screen_width, screen_height)
    data = gui.create_gui(world_width, world_height, start_generation_at, screen_width, screen_height);

    waitfor(data.fig);
endfunction

init(ROWS, COLS, START_GENERATION_AT, SCREEN_WIDTH, SCREEN_HEIGHT);
