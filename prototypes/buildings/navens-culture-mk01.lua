local MODULE_SLOTS = 4

RECIPE {
    type = "recipe",
    name = "navens-culture-mk01",
    energy_required = 1,
    enabled = false,
    ingredients = {
        {type = "item", name = "gasifier",         amount = 2},
        {type = "item", name = "glass",            amount = 30},
        {type = "item", name = "nexelit-plate",    amount = 20},
        {type = "item", name = "duralumin",        amount = 35},
        {type = "item", name = "steel-plate",      amount = 50},
        {type = "item", name = "steam-engine",     amount = 1},
        {type = "item", name = "advanced-circuit", amount = 15},
        {type = "item", name = "tin-plate",        amount = 50},
    },
    results = {
        {type = "item", name = "navens-culture-mk01", amount = 1}
    }
}:add_unlock("navens"):add_ingredient {type = "item", name = "small-parts-01", amount = 30}

ITEM {
    type = "item",
    name = "navens-culture-mk01",
    icon = "__pyalienlifegraphics__/graphics/icons/navens-culture-mk01.png",
    icon_size = 64,
    flags = {},
    subgroup = "py-alienlife-farm-buildings-mk01",
    order = "b",
    place_result = "navens-culture-mk01",
    stack_size = 10
}

ENTITY {
    type = "assembling-machine",
    name = "navens-culture-mk01",
    icon = "__pyalienlifegraphics__/graphics/icons/navens-culture-mk01.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "navens-culture-mk01"},
    fast_replaceable_group = "navens-culture",
    max_health = 50,
    corpse = "medium-remnants",
    dying_explosion = "big-explosion",
    collision_box = {{-4.8, -4.8}, {4.8, 4.8}},
    selection_box = {{-5.0, -5.0}, {5.0, 5.0}},
    forced_symmetry = "diagonal-pos",
    module_slots = MODULE_SLOTS,
    allowed_effects = {"speed", "productivity", "consumption", "pollution", "quality"},
    crafting_categories = {"navens"},
    crafting_speed = py.farm_speed(MODULE_SLOTS, .6, 7.5),
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = {
            pollution = -1
        },
    },
    energy_usage = "400kW",
    graphics_set = {
        animation = {
            layers = {
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a1.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, 128)
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a1-mask.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, 128),
                    tint = {r = 1.0, g = 1.0, b = 0.0, a = 1.0}
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a2.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, 64)
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a2-mask.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, 64),
                    tint = {r = 1.0, g = 1.0, b = 0.0, a = 1.0}
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a3.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, 0)
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a3-mask.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, 0),
                    tint = {r = 1.0, g = 1.0, b = 0.0, a = 1.0}
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a4.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, -64)
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a4-mask.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, -64),
                    tint = {r = 1.0, g = 1.0, b = 0.0, a = 1.0}
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a5.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, -128)
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a5-mask.png",
                    width = 352,
                    height = 64,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, -128),
                    tint = {r = 1.0, g = 1.0, b = 0.0, a = 1.0}
                },
                {
                    filename = "__pyalienlifegraphics2__/graphics/entity/navens-culture/a6.png",
                    width = 352,
                    height = 32,
                    line_length = 5,
                    frame_count = 120,
                    animation_speed = 0.4,
                    shift = util.by_pixel(16, -176)
                },
            }
        },
    },

    fluid_boxes_off_when_no_fluid_recipe = true,
    fluid_boxes = {
        --1
        {
            production_type = "input",
            pipe_covers = py.pipe_covers(false, true, true, true),
            pipe_picture = py.pipe_pictures("assembling-machine-3", nil, {0.0, -0.88}, nil, nil),
            volume = 1000,
            pipe_connections = {{flow_direction = "input", position = {1.5, -4.5}, direction = defines.direction.north}}
        },
        {
            production_type = "input",
            pipe_covers = py.pipe_covers(false, true, true, true),
            pipe_picture = py.pipe_pictures("assembling-machine-3", nil, {0.0, -0.88}, nil, nil),
            volume = 1000,
            pipe_connections = {{flow_direction = "input", position = {-1.5, -4.5}, direction = defines.direction.north}}
        },
        {
            production_type = "output",
            pipe_covers = py.pipe_covers(false, true, true, true),
            pipe_picture = py.pipe_pictures("assembling-machine-3", nil, {0.0, -0.88}, nil, nil),
            volume = 100,
            pipe_connections = {{flow_direction = "output", position = {1.5, 4.5}, direction = defines.direction.south}}
        },
        {
            production_type = "output",
            pipe_covers = py.pipe_covers(false, true, true, true),
            pipe_picture = py.pipe_pictures("assembling-machine-3", nil, {0.0, -0.88}, nil, nil),
            volume = 100,
            pipe_connections = {{flow_direction = "output", position = {-1.5, 4.5}, direction = defines.direction.south}}
        },
    },
    impact_category = "metal-large",
    working_sound = {
        sound = {filename = "__pyalienlifegraphics__/sounds/navens-culture.ogg", volume = 1.8},
        idle_sound = {filename = "__pyalienlifegraphics__/sounds/navens-culture.ogg", volume = 0.3},
        apparent_volume = 2.5
    }
}
