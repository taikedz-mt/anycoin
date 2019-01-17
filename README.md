# AnyCoin

Create coins from anything, and assign them value.

Use it as currency, or put them in frames for fame!

The base AnyCoin, FiverCoin and TennerCoin come as standard, as well as the mineral coins, you can specify your own coins from within your own mod using the `anycoin` API

Uses tin as base metal.

## Minerals coins

Basic minerals can be mined and turned into coins - supported are

* iron coins (20 ac-)
* copper coins (50 ac-)
* bronze coins (100 ac-)
* gold coins (200 ac-)
* diamond coins (500 ac-)
* mese coins (1000 ac-)

## API

Very simple. Add a dependency to `anycoin` and user `anycoin:register_coin(name, coin_definition)` with a table as follows

    name         -- basic coin name, e.g. 'coal' to make a 'anycoin:coin_coal'
                    coin

    coin_definition => {

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
                        maximum size of ItemStack (default 99)
    }

## License

This code was extracted from my old modpack "Vivarium" to be a standalone mod.

* Source code - Tai "DuCake" Kedzierski, conveyed under the terms of the GNU Lesser GPL v3
* Media - CC-BY-SA 4.0 - Tai "DuCake" Kedzierski, provided under the Creative Commons Attribution, Share-Alike 4.0 license, international.
