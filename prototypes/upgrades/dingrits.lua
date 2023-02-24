local FUN = require '__pycoalprocessing__/prototypes/functions/functions'

if data then
    data:extend{
        {
            type = 'module',
            name = 'dingrits-alpha',
            stack_size = 50,
            subgroup = 'py-alienlife-modules',
            category = 'dingrits',
            icon = '__pyalienlifegraphics__/graphics/icons/dingrits.png',
            icon_size = 64,
            tier = 5,
            order = 'd-e',
            effect = {pollution = {bonus = 1},speed = {bonus = 8},productivity={bonus = 0.1}},
            limitation = {},
            limitation_message_key = 'dingrits',
            fuel_category = 'dingrits',
            fuel_value = '250MJ',
            burnt_result = 'used-dingrit'
        },
        {
            type = 'recipe',
            name = 'dingrits-alpha',
            enabled = false,
            energy_required = 36000,
            ingredients = {{'dingrits-mk04', 1}},
            results = {{name = 'dingrits-alpha', probability = 0.5, type = 'item', amount = 1}},
            category = 'dingrits'
        }
    }

    for i, recipe in pairs({
        table.deepcopy(data.raw.recipe['ex-blo-din']),
        table.deepcopy(data.raw.recipe['ex-bon-din']),
        table.deepcopy(data.raw.recipe['ex-bra-din']),
        table.deepcopy(data.raw.recipe['ex-gut-din']),
        table.deepcopy(data.raw.recipe['ex-me-din']),
        table.deepcopy(data.raw.recipe['ex-pelt-din']),
    }) do
        recipe.localised_name = {'recipe-name.'..recipe.name}
        recipe.name = recipe.name .. '-mutation'
        for _, result in pairs(recipe.results) do
            if result.name ~= 'cage' then
                local amount = result.amount or ((result.amount_min + result.amount_max) / 2)
                result.amount_min = math.ceil(amount / 2)
                result.amount_max = math.ceil(amount * 2)
                result.amount = nil
            end
        end
        data:extend{recipe}
    end

    for i, recipe in pairs({
        table.deepcopy(data.raw.recipe['dingrits-1']),
        table.deepcopy(data.raw.recipe['dingrits-2']),
        table.deepcopy(data.raw.recipe['dingrits-3']),
        table.deepcopy(data.raw.recipe['dingrits-4']),
    }) do
        recipe.name = recipe.name .. '-training'
        FUN.add_result(recipe, {type = 'item', amount = 1, probability = 0.5, name = 'dingrits-food-01'})
        if i > 2 then FUN.add_result(recipe, {type = 'item', amount = 1, probability = 0.5, name = 'dingrits-food-02'}) end
        data:extend{recipe}
    end
end

return {
    affected_entities = { -- the entities that should be effected by this tech upgrade
        'dingrits-pack-mk01',
        'dingrits-pack-mk02',
        'dingrits-pack-mk03',
        'dingrits-pack-mk04',
    },
    master_tech = { -- tech that is shown in the tech tree
        name = 'dingrits-upgrade',
        icon = '__pyalienlifegraphics3__/graphics/technology/updates/u-dingrits.png',
        icon_size = 128,
        order = 'c-a',
        prerequisites = {'dingrits-mk04'},
        unit = {
            count = 500,
            ingredients = {
                {'automation-science-pack', 1},
                {'py-science-pack-1', 1},
                {'logistic-science-pack', 1},
                {'military-science-pack', 1},
                {'py-science-pack-2', 1},
                {'chemical-science-pack', 1},
                {'py-science-pack-3', 1},
                {'production-science-pack', 1},
                {'py-science-pack-4', 1},
                {'utility-science-pack', 1},
            },
            time = 45
        }
    },
    sub_techs = {
        {
            name = 'alpha',
            icon = '__pyalienlifegraphics3__/graphics/technology/alpha.png',
            icon_size = 128,
            order = 'c-a',
            effects = { -- the effects the tech will have on the building. valid types: 'module-effects', 'unlock-recipe', 'lock-recipe', 'recipe-replacement'
                {recipe = 'dingrits-alpha', type = 'unlock-recipe'}
            },
        },
        {
            name = 'c-mutation',
            icon = '__pyalienlifegraphics3__/graphics/technology/c-mutation.png',
            icon_size = 128,
            order = 'c-a',
            effects = { -- the effects the tech will have on the building. valid types: 'module-effects', 'unlock-recipe', 'lock-recipe', 'recipe-replacement'
                {old = 'ex-blo-din', new = 'ex-blo-din-mutation', type = 'recipe-replacement'},
                {old = 'ex-me-din', new = 'ex-me-din-mutation', type = 'recipe-replacement'},
                {old = 'ex-bra-din', new = 'ex-bra-din-mutation', type = 'recipe-replacement'},
                {old = 'ex-gut-din', new = 'ex-gut-din-mutation', type = 'recipe-replacement'},
                {old = 'ex-pelt-din', new = 'ex-pelt-din-mutation', type = 'recipe-replacement'},
                {old = 'ex-bon-din', new = 'ex-bon-din-mutation', type = 'recipe-replacement'},
            }
        },
        {
            name = 'training',
            icon = '__pyalienlifegraphics3__/graphics/technology/training.png',
            icon_size = 128,
            order = 'c-a',
            effects = { -- the effects the tech will have on the building. valid types: 'module-effects', 'unlock-recipe', 'lock-recipe', 'recipe-replacement'
                {old = 'dingrits-1', new = 'dingrits-1-training', type = 'recipe-replacement'},
                {old = 'dingrits-2', new = 'dingrits-2-training', type = 'recipe-replacement'},
                {old = 'dingrits-3', new = 'dingrits-3-training', type = 'recipe-replacement'},
                {old = 'dingrits-4', new = 'dingrits-4-training', type = 'recipe-replacement'},
            }
        }
    },
    module_category = 'dingrits'
}