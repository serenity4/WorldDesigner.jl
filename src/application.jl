main(; async = false) = Anvil.main(start_app; async)

function start_app()
  characters_tab = add_left_tab("Characters")
  places_tab = add_left_tab("Places")
  events_tab = add_left_tab("Events")
  left_tabs = EntityID[characters_tab, places_tab, events_tab]

  @set_name central_panel = Rectangle((20, 18), RGB(0.01, 0.01, 0.01))
  for left_tab in left_tabs
    add_constraint(attach(left_tab |> at(:edge, :right), central_panel |> at(:edge, :left)))
  end
  add_constraint(attach(characters_tab |> at(:edge, :top), central_panel |> at(:edge, :top) |> at(-2)))
  add_constraint(distribute(left_tabs, :vertical, 1, :geometry))

  # File menu.
  file_menu_head = Button(() -> collapse!(file_menu), (3, 1); text = Text("File"))
  file_menu_item_1 = MenuItem(Text("New file"), (3, 1)) do; end
  file_menu_item_2 = MenuItem(Text("Open..."), (3, 1)) do; end
  file_menu_item_3 = MenuItem(Anvil.exit, Text("Exit"), (3, 1), 'x')
  @set_name file_menu = Menu(file_menu_head, [file_menu_item_1, file_menu_item_2, file_menu_item_3], 'F')
  add_constraint(attach(file_menu |> at(:corner, :top_left), app.windows[app.window] |> at(:corner, :top_left)))

  # Edit menu.
  edit_menu_head = Button(() -> collapse!(edit_menu), (3, 1); text = Text("Edit"))
  edit_menu_item_1 = MenuItem(Text("Regenerate"), (3, 1)) do; end
  @set_name edit_menu = Menu(edit_menu_head, [edit_menu_item_1], 'E')
  add_constraint(attach(edit_menu |> at(:corner, :top_left), file_menu |> at(:corner, :top_right)))
end

function add_left_tab(name)
  @set_name tab = Image(get_texture("tab-left.png"), 6)
  @set_name text = Text(styled"{black:$name}"; font = "MedievalSharp", size = 0.7)
  put_behind(tab, text)
  add_constraint(attach(text, tab |> at(0.2, 0)))
  tab
end
