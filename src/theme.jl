ACTIVE_TAB_COLOR::String = "#0000ff"
INACTIVE_TAB_COLOR::String = "black"
DEFAULT_CHARACTER_NODE_SIZE::Float64 = 2
DEFAULT_PLACE_NODE_SIZE::Float64 = 2
DEFAULT_EVENT_NODE_SIZE::Float64 = 2

function update_theme()
  @eval Anvil begin
    BACKGROUND_COLOR = RGB(0.01, 0.01, 0.02)
  end
end
