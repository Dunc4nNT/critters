clear all;
close all;

ROWS = uint32(100);
COLS = uint32(200);
START_GENERATION_AT = uint32(0);

screensize = get(0.0, "screensize")(3:4);
[SCREEN_WIDTH, SCREEN_HEIGHT] = num2cell(screensize){:};
clear screensize;

function init(world_width, world_height, start_generation_at, screen_width, screen_height)
    data.SCREEN_WIDTH = screen_width;
    data.SCREEN_HEIGHT = screen_height;
    data.primary_colour = [1.0, 1.0, 1.0];
    data.secondary_colour = [0.0, 0.0, 0.0];
    data.tertiary_colour = [0.6, 0.0, 0.0];
    data.world = critters_world(world_width, world_height, start_generation_at);

    data.fig = figure(
        "name", "Critters",
        "numbertitle", "off",
        "units", "pixels",
        "resize", "off",
        "menubar", "none",
        "color", data.tertiary_colour,
        "position", [(data.SCREEN_WIDTH - 1600) / 2, (data.SCREEN_HEIGHT - 900) / 2, 1600, 900]
    );

    data.axs = axes(
        "units", "pixels",
        "position", [0, 100, 1600, 800],
        "colormap", [data.secondary_colour; data.primary_colour]
    );

    data.img = imagesc(data.axs, data.world.get_cells);
    axis(data.axs, "off");

    data.next_step_button = uicontrol(
        "style", "pushbutton",
        "units", "pixels",
        "string", "Next Step",
        "foregroundcolor", data.primary_colour,
        "backgroundcolor", data.secondary_colour,
        "position", [25, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Step to the next generation.",
        "callback", @on_next_step
    );

    data.reset_button = uicontrol(
        "style", "pushbutton",
        "units", "pixels",
        "selectionhighlight", "on",
        "string", "Reset World",
        "foregroundcolor", data.primary_colour,
        "backgroundcolor", data.secondary_colour,
        "position", [250, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Reset world with random cells.",
        "callback", @on_reset
    );

    data.generation_label = uicontrol(
        "style", "text",
        "units", "pixels",
        "string", data.world.generation_str(),
        "foregroundcolor", data.primary_colour,
        "backgroundcolor", data.secondary_colour,
        "position", [500, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16
    );

    guidata(data.fig, data);
    drawnow();

    waitfor(data.fig);
endfunction

function on_next_step(source, event)
    data = guidata(source);

    data.world = data.world.next_step();

    set(data.img, "cdata", data.world.cells);
    set(data.generation_label, "string", data.world.generation_str());
    guidata(source, data);
endfunction

function on_reset(source, event)
    data = guidata(source);

    data.world = data.world.reset_world();

    set(data.img, "cdata", data.world.cells);
    set(data.generation_label, "string", data.world.generation_str());
    guidata(source, data);
endfunction

init(ROWS, COLS, START_GENERATION_AT, SCREEN_WIDTH, SCREEN_HEIGHT);
