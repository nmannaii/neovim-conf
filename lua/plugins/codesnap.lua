return {
  "mistricky/codesnap.nvim",
  config = function()
    require("codesnap").setup({
      snapshot_config = {
        theme = "candy",
        window = {
          mac_window_bar = true,
          shadow = {
            radius = 20,
            color = "#00000040",
          },
          margin = {
            x = 82,
            y = 82,
          },
          border = {
            width = 1,
            color = "#ffffff30",
          },
          title_config = {
            color = "#ffffff",
            font_family = "Pacifico",
          },
        },
        themes_folders = {},
        fonts_folders = {},
        line_number_color = "#495162",
        command_output_config = {
          prompt = "❯",
          font_family = "CaskaydiaCove Nerd Font",
          prompt_color = "#F78FB3",
          command_color = "#98C379",
          string_arg_color = "#ff0000",
        },
        code_config = {
          font_family = "CaskaydiaCove Nerd Font",
          breadcrumbs = {
            enable = true,
            separator = "/",
            color = "#80848b",
            font_family = "CaskaydiaCove Nerd Font",
          },
        },
        watermark = {
          content = "Najmedine",
          font_family = "Pacifico",
          color = "#ffffff",
        },
      },
    })
  end
}
