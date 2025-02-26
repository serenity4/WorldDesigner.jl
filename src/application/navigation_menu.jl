function add_file_menu!(state::ApplicationState)
  @set_name "navigation/file" background = Rectangle((3, 1), Anvil.MENU_ITEM_COLOR)
  @set_name "navigation/file" text = Text("File")
  place(at(text, :center), at(background, :center))
  menu = Menu(background, 'F'; on_expand = menu -> generate_file_menu!(menu, state), on_collapse = close!)
  place(background |> at(:top_left), app.windows[app.window] |> at(:top_left))
  menu
end

function add_edit_menu!(state::ApplicationState)
  @set_name "navigation/edit" background = Rectangle((3, 1), Anvil.MENU_ITEM_COLOR)
  @set_name "navigation/edit" text = Text("Edit")
  place(at(text, :center), at(background, :center))
  menu = Menu(background, 'E'; on_expand = menu -> generate_edit_menu!(menu, state), on_collapse = close!)
  menu
end

on_active(widget) = active -> widget.color = ifelse(active, Anvil.MENU_ITEM_ACTIVE_COLOR, Anvil.MENU_ITEM_COLOR)

generate_menu_item(f, text::AbstractString, dimensions; shortcut = nothing) = generate_menu_item(f, Text(text), dimensions; shortcut)

function generate_menu_item(f, text::Text, dimensions; shortcut = nothing)
  background = Rectangle(dimensions, Anvil.MENU_ITEM_COLOR)
  place(at(text, :left), at(background, :left) |> at(0.2, 0.0))
  put_in_front(text, background)
  MenuItem(f, background; text, on_active = on_active(background), shortcut)
end

function generate_file_menu!(menu::Menu, state::ApplicationState)
  dimensions = (3, 1)
  items = MenuItem[]

  push!(items, generate_menu_item("New file", dimensions) do
  end)

  push!(items, generate_menu_item("Open...", dimensions) do
  end)

  push!(items, generate_menu_item(Anvil.exit, "Exit", dimensions; shortcut = 'x'))

  align([at(item.widget, :left) for item in items], at(menu.head, :left), :vertical)
  distribute([menu.head; [item.widget for item in items]], :vertical; spacing = 0, mode = :geometry)
  add_menu_items!(menu, items)
end

function generate_edit_menu!(menu::Menu, state::ApplicationState)
  dimensions = (3, 1)
  items = MenuItem[]

  push!(items, generate_menu_item("Regenerate", dimensions) do
  end)

  align([at(item.widget, :left) for item in items], at(menu.head, :left), :vertical)
  distribute([menu.head; [item.widget for item in items]], :vertical; spacing = 0, mode = :geometry)
  add_menu_items!(menu, items)
end
