anycoin = {}
local use_mineral_coins = minetest.settings:get_bool("anycoin.mineral_coins") == true

local basemetal = "default:tin_ingot"

function anycoin:register_coin(name, coindef)
    --[[
    name         -- basic coin name, e.g. 'coal' to make a 'anycoin:coin_coal'
                    coin

    coindef => {

        description  -- Coin description for tooltip, e.g. 'Coal Coin'

        material     -- Material variant to use with base metal to make the coin

        value        -- (optional)
                        The value of the coin, default 1

        base_image   -- (optional)
                        the base texture to use for the coin
                        if not specified, uses the default coin texture

        face_image   -- (optional)
                        overlay image for the coin, on top of the base image
                        if not specified, no overlay used

        stack_max    -- (optional)
                        maximum size of ItemStack, default 99
    }
    --]]

	local coinimg = "anycoin_coin.png"
    if coindef.base_image then
        coinimg = coindef.base_image
    end

    if coindef.face_image then
        coinimg = coinimg."^"..overimg
    end

	local value = tonumber(coindef.value) or 1
    value = math.floor(value)

	minetest.register_craftitem(":anycoin:"..name, {
		description = coindef.description .. " ("..value.." ac-)",
		inventory_image = coinimg,
		--coinvalue = value,
        stack_max = coindef.stack_max or 99,
	})

    if coindef.material then
        minetest.register_craft( {
            output = "anycoin:"..coindef.name,
            recipe = {
                {"",basemetal,""},
                {basemetal,coindef.material,basemetal},
                {"",basemetal,""},
            }

        })
    end

end

-- Convert amongst coins
local function register_coin_conversion(lower, upper)
    if not lower then return false end

    local lvalue = coin_values[lower].value
    local uvalue = coin_values[upper].value

    -- Only process when upper divisble by lower
    if math.fmod(uvalue,lvalue) ~= 0 then return false end
    local dvalue = uvalue/lvalue

    if dvalue > 9 then return false end

    local recipe_stack = {}
    for i=1,dvalue do
        recipe_stack[#recipe_stack+1] = "anycoin:"..lower
    end

    minetest.register_craft( {
        output = "anycoin:"..upper,
        type = "shapeless",
        recipe = recipe_stack
    })

    minetest.register_craft( {
        type = "shapeless",
        output = "anycoin:"..lower.." "..dvalue,
        recipe = {"anycoin:"..upper}

    })

    return true
end

-- A set of coins to serve as an exchange base

local coin_definitions = {
    anycoin = {
        description = "AnyCoin",
        value = 1,
        material = "default:tin_ingot",
    },
    fivercoin = {
        description = "FiverCoin",
        value = 5,
        face_image = "[colorize:green:60",
        divides_into = "anycoin",
    },
    tennercoin = {
        description = "TennerCoin",
        value = 10,
        face_image = "[colorize:purple:60",
        divides_into = "fivercoin",
    },
}

-- Some extra denominations

local mineral_coins = {
    iron_coin = {
        description = "Iron Coin",
        material = "default:iron_ingot",
        face_image = "[colorize:red:50",
        value = 20,
        divides_into = "tennercoin",
    },
    copper_coin = {
        description = "Copper Coin",
        material = "default:copper_ingot",
        face_image = "[colorize:orange:30",
        value = 50,
        divides_into = "tennercoin",
    },
    bronze_coin = {
        description = "Bronze Coin",
        material = "default:bronze_ingot",
        base_image = "anycoin_squarecoin.png",
        face_image = "[colorize:orange:90",
        value = 100,
        divides_into = "copper_coin",
    },
    gold_coin = {
        description = "Gold Coin",
        material = "default:gold_ingot",
        face_image = "[colorize:yellow:90",
        value = 200,
        divides_into = "bronze_coin",
    },
    diamond_coin = {
        description = "Diamond Coin",
        material = "default:diamond",
        base_image = "anycoin_squarecoin.png",
        face_image = "[colorize:blue:90",
        value = 500,
        divides_into = "bronze_coin",
    },
    mese_coin = {
        description = "Mese Coin",
        material = "default:mese_crystal",
        base_image = "anycoin_squarecoin.png",
        face_image = "[colorize:yellow:90",
        value = 1000,
        divides_into = "diamond_coin",
    },
}

local function process_definitions(def_table)
    for coinname,coindef in pairs(def_table) do
        register_coin(coinname, coindef)
        register_coin_conversion(coindef.divides_into, coinname)
    end
end

process_definitions(coin_definitions)

if use_mineral_coins then
    process_definitions(mineral_coins)
end
