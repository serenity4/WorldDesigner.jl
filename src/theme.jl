ACTIVE_TAB_COLOR::String = "#0000ff"
INACTIVE_TAB_COLOR::String = "black"

function update_theme()
  @eval Anvil begin
    BACKGROUND_COLOR = RGB(0.01, 0.01, 0.02)
  end
end
