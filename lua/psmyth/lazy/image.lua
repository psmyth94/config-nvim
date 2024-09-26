return {
    "3rd/image.nvim",
    dependencies = {
        "leafo/magick",
        {
            "vhyrro/luarocks.nvim",
            opts = {
                rocks = {
                    hererocks = true,
                },
            },
        },
    },
}
