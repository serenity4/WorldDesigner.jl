main(; async = false) = Anvil.main(start_app; async)

function start_app()
  @set_name characters_tab = Image(get_texture("tab-left.png"), 0.5)
  @set_name characters_tab_text = Text(styled"{black:Characters}"; font = "MedievalSharp", size = 40)
  add_constraint(attach(characters_tab_text |> at(:edge, :top), characters_tab |> at(:edge, :top) |> at(-0.035)))
  add_constraint(attach(characters_tab_text |> at(:edge, :left), characters_tab |> at(:edge, :left) |> at(0.06)))
  @set_name places_tab = Image(get_texture("tab-left.png"), 0.5)
  @set_name events_tab = Image(get_texture("tab-left.png"), 0.5)
  left_tabs = EntityID[characters_tab, places_tab, events_tab]

  @set_name central_panel = Rectangle((2.0, 1.8), RGB(0.01, 0.01, 0.01))
  for left_tab in left_tabs
    add_constraint(attach(left_tab |> at(:edge, :right), central_panel |> at(:edge, :left)))
  end
  add_constraint(attach(characters_tab |> at(:edge, :top), central_panel |> at(:edge, :top) |> at(-0.2)))
  add_constraint(distribute(left_tabs, :vertical, 0.1, :geometry))

  # File menu.
  file_menu_head = Button(() -> collapse!(file_menu), (0.3, 0.1); text = Text("File"))
  file_menu_item_1 = MenuItem(Text("New file"), (0.3, 0.1)) do
    save_button.background.color = RGB{Float32}(0.1, 0.3, 0.2)
  end
  file_menu_item_2 = MenuItem(Text("Open..."), (0.3, 0.1)) do
    save_button.background.color = RGB{Float32}(0.3, 0.2, 0.1)
  end
  file_menu_item_3 = MenuItem(Anvil.exit, Text("Exit"), (0.3, 0.1), 'x')
  @set_name file_menu = Menu(file_menu_head, [file_menu_item_1, file_menu_item_2, file_menu_item_3], 'F')
  add_constraint(attach(file_menu |> at(:corner, :top_left), app.windows[app.window] |> at(:corner, :top_left)))

  # Edit menu.
  edit_menu_head = Button(() -> collapse!(edit_menu), (0.3, 0.1); text = Text("Edit"))
  edit_menu_item_1 = MenuItem(Text("Regenerate"), (0.3, 0.1)) do
  end
  @set_name edit_menu = Menu(edit_menu_head, [edit_menu_item_1], 'E')
  add_constraint(attach(edit_menu |> at(:corner, :top_left), file_menu |> at(:corner, :top_right)))
end
