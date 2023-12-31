meta = {
    name = "Lazarus Ranked",
    version = "0.4",
    author = "Nitroxy",
    description = ""
}

--5

local prev_option = 1;

local stuff = import("Nitroxy/Lazarus Ankh", "8.5");

local saved_data = {
    penalty = 30,
    sc_penalty = 30
}

set_callback(function (save_ctx)
    local save_data_str = json.encode(saved_data);
    save_ctx:save(save_data_str);
end, ON.SAVE)

set_callback(function(load_ctx)
    local load_data_str = load_ctx:load();
    print(inspect(load_data_str));
    if load_data_str ~= "" then
        saved_data = json.decode(load_data_str);
        load_penalty();
    end
end, ON.LOAD)

set_callback(function ()
    -- Save one last time
    update_penalty();
    -- Reset penalty
    stuff.set_penalty(30 * 60);
end, ON.SCRIPT_DISABLE)

set_callback(function ()
    if(prev_option ~= options.a_mode)then
        load_penalty();
        prev_option = options.a_mode;
    end
end, ON.GUIFRAME)

register_option_combo("a_mode", "Category", "", "Any%\0SunkenCity\0\0", 1);

register_option_int("b_penalty", "", "", 30, 0, 0);

register_option_button("c_update", "Update penalty", "", function ()
    update_penalty();
end)

function update_penalty()
    if(options.a_mode == 1)then
        saved_data.penalty = options.b_penalty;
    else
        saved_data.sc_penalty = options.b_penalty;
    end
    stuff.set_penalty(options.b_penalty * 60);
    save_progress();
    print("Updated!");
end

function load_penalty()
    if(options.a_mode == 1)then
        options.b_penalty = saved_data.penalty
    else
        options.b_penalty = saved_data.sc_penalty
    end
    stuff.set_penalty(options.b_penalty * 60);
end
