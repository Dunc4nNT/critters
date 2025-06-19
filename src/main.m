clear all;
close all;

ROWS = uint32(100);
COLS = uint32(150);
START_GENERATION_AT = uint32(0);

screensize = get(0.0, "screensize")(3:4);
[SCREEN_WIDTH, SCREEN_HEIGHT] = num2cell(screensize){:};
clear screensize;

function init(world_width, world_height, start_generation_at, screen_width, screen_height)
    data.SCREEN_WIDTH = screen_width;
    data.SCREEN_HEIGHT = screen_height;
    data.primary_colour_200 = [0.8627450980392157, 0.8901960784313725, 0.8941176470588236];
    data.secondary_colour_300 = [0.8117647058823529, 0.7098039215686275, 0.803921568627451];
    data.secondary_colour_600 = [0.43529411764705883, 0.28627450980392155, 0.42745098039215684];
    data.secondary_colour_800 = [0.1450980392156863, 0.09411764705882353, 0.1411764705882353];
    data.colour_white = [1, 1, 1];
    data.colour_grey_200 = [0.8509803921568627, 0.8509803921568627, 0.8509803921568627];
    data.colour_grey_800 = [0.25098039215686274, 0.25098039215686274, 0.25098039215686274];
    data.colour_black = [0, 0, 0];
    data.world = critters_world(world_width, world_height, start_generation_at);
    data.valid_file_formats = {"*.txt;*.csv", "Text Files"; "*.png;", "Images"};
    data.is_playing = false;
    data.default_play_speed = 0.5;
    data.play_speed = data.default_play_speed;
    data.colourmap = [data.secondary_colour_800; data.primary_colour_200];

    data.fig = figure(
        "name", "Critters",
        "numbertitle", "off",
        "units", "pixels",
        "resize", "off",
        "menubar", "none",
        "color", data.secondary_colour_600,
        "position", [(data.SCREEN_WIDTH - 1600) / 2, (data.SCREEN_HEIGHT - 800) / 2, 1600, 800]
    );

    data.axs = axes(
        "units", "normalized",
        "position", [0, 0, 0.75, 1],
        "colormap", data.colourmap
    );

    data.img = imagesc(data.axs, data.world.get_cells);
    axis(data.axs, "off");

    data.previous_step_button = uicontrol(
        "style", "pushbutton",
        "units", "normalized",
        "string", "Previous Step",
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [0.80, 0.80, 0.15, 0.05],
        "fontunits", "normalized",
        "fontsize", 0.5,
        "tooltipstring", "Step to the previous generation.",
        "callback", @on_previous_step
    );

    data.next_step_button = uicontrol(
        "style", "pushbutton",
        "units", "pixels",
        "string", "Next Step",
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [250, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Step to the next generation.",
        "callback", @on_next_step
    );

    data.reset_button = uicontrol(
        "style", "pushbutton",
        "units", "pixels",
        "string", "Reset World",
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [475, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Reset world with random cells.",
        "callback", @on_reset
    );

    data.generation_label = uicontrol(
        "style", "text",
        "units", "pixels",
        "string", data.world.generation_str(),
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [700, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16
    );

    data.export_button = uicontrol(
        "style", "pushbutton",
        "units", "pixels",
        "string", "Export World",
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [925, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Export the world.",
        "callback", @on_export
    );

    data.import_button = uicontrol(
        "style", "pushbutton",
        "units", "pixels",
        "string", "Import World",
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [1150, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Import a world.",
        "callback", @on_import
    );

    data.toggle_play_button = uicontrol(
        "style", "togglebutton",
        "units", "pixels",
        "string", "Toggle Play",
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [1375, 25, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Play or pause the automaton simulation.",
        "callback", @on_toggle_play
    );

    data.adjust_speed_button = uicontrol(
        "style", "slider",
        "units", "pixels",
        "string", "Speed",
        "value", data.default_play_speed,
        "sliderstep", [0.01, 0.1],
        "foregroundcolor", data.colour_grey_800,
        "backgroundcolor", data.secondary_colour_300,
        "position", [1375, 100, 200, 50],
        "fontunits", "pixels",
        "fontsize", 16,
        "tooltipstring", "Adjust the simulation speed.",
        "callback", @on_adjust_speed
    );

    guidata(data.fig, data);
    drawnow();

    waitfor(data.fig);
endfunction

% Update world and UI elements.
function update_gui(data, source)
    % To prevent constant flickering of the screen, invert the colours on odd steps.
    if (isequal(class(data.world), "critters_world"))
        if (mod(data.world.get_generation(), 2) == 0)
            set(data.axs, "colormap", data.colourmap);
        else
            set(data.axs, "colormap", flipud(data.colourmap));
        endif
    endif

    set(data.img, "cdata", data.world.cells);
    set(data.generation_label, "string", data.world.generation_str());
    guidata(source, data);
    drawnow();
endfunction

function on_previous_step(source, event)
    data = guidata(source);

    data.world = data.world.previous_step();

    update_gui(data, source);
endfunction

function on_next_step(source, event)
    data = guidata(source);

    data.world = data.world.next_step();

    update_gui(data, source);
endfunction

function on_reset(source, event)
    data = guidata(source);

    data.world = data.world.reset_world();

    update_gui(data, source);
endfunction

function on_export(source, event)
    data = guidata(source);

    [filename, filepath] = uiputfile(
        data.valid_file_formats,
        "Choose a file name to save",
        "world.txt"
    );

    if (endsWith(filename, {".png"}))
        imwrite(data.world.cells, [filepath, filename]);
    elseif (endsWith(filename, {".txt", ".csv"}))
        csvwrite([filepath, filename], data.world.cells);
    else
        errordlg("File save format not supported.", "SAVE ERROR");
        return;
    endif
endfunction

function on_import(source, event)
    data = guidata(source);

    [filename, filepath] = uigetfile(
        data.valid_file_formats,
        "Select a file to load.",
        "world.txt"
    );

    if (endsWith(filename, {".png"}))
        imported_world = imread([filepath, filename]);
    elseif (endsWith(filename, {".txt", ".csv"}))
        imported_world = csvread([filepath, filename]);
    else
        errordlg("File save format not supported.", "Error Saving");
        return;
    endif

    try
        data.world = data.world.set_cells(logical(imported_world));
    catch err
        errordlf(err.message, "IMPORT ERROR");
        return;
    end_try_catch

    update_gui(data, source);
endfunction

function on_toggle_play(source, event)
    data = guidata(source);

    data.is_playing = get(gcbo, "value");
    guidata(source, data);

    while data.is_playing
        data.world = data.world.next_step();

        update_gui(data, source);
        pause(1.25 - data.play_speed);

        % BUG: when exiting the application while playing is on, this errors as source is no longer valid.
        data = guidata(source);
    endwhile
endfunction

function on_adjust_speed(source, event)
    data = guidata(source);

    data.play_speed = get(gcbo, "value");
    guidata(source, data);
endfunction

init(ROWS, COLS, START_GENERATION_AT, SCREEN_WIDTH, SCREEN_HEIGHT);
