defmodule SpiralbenchWeb.SpiralLive do
  use SpiralbenchWeb, :live_view
  @wrapper_width 960
  @wrapper_height 720
  @cell_size 10
  @step @cell_size * 0.015
  @center_x @wrapper_width / 2
  @center_y @wrapper_height / 2
  @max min(@wrapper_width, @wrapper_height) / 2

  defmacro sigil_Z({:<<>>, meta, [expr]}, modifiers)
           when modifiers == [] or modifiers == ~c"noformat" do
    if not Macro.Env.has_var?(__CALLER__, {:assigns, nil}) do
      raise "~Z requires a variable named \"assigns\" to exist and be set to a map"
    end

    options = [
      engine: Phoenix.LiveView.TagEngine,
      file: __CALLER__.file,
      line: __CALLER__.line + 1,
      caller: __CALLER__,
      indentation: meta[:indentation] || 0,
      source: expr,
      tag_handler: Phoenix.LiveView.HTMLEngine
    ]

    quoted = EEx.compile_string(expr, options)

    Macro.to_string(quoted) |> IO.puts()

    quoted
  end


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # @impl true
  # def render(assigns) do
  #   # tiles = TileData.tiles()
  #   tiles = build_tiles(0, 0, [])
  #   assigns = assign(assigns, :tiles, tiles)

  #   require Phoenix.LiveView.TagEngine

  #   (
  #     require Phoenix.LiveView.Engine

  #     (
  #       dynamic = fn track_changes? ->
  #         changed =
  #           case assigns do
  #             %{__changed__: changed} when track_changes? -> changed
  #             _ -> nil
  #           end

  #         v1 =
  #           case Phoenix.LiveView.Engine.changed_assign?(changed, :tiles) do
  #             true ->
  #               for = Phoenix.LiveView.Comprehension.__mark_consumable__(assigns.tiles)

  #               Phoenix.LiveView.Comprehension.__annotate__(
  #                 %Phoenix.LiveView.Comprehension{
  #                   # static: ["\n    <div class=\"title\" style=\"left: 123px; top: 456px;\"></div>\n  "],
  #                   static: ["\n    <div class=\"tile\" style=\"", "\"></div>\n  "],
  #                   dynamics:
  #                     for [x, y] <- for do
  #                       v0 = [~c"left: ", [x, [~c"px; top: ", [y, [~c"px;"]]]]]
  #                         Phoenix.LiveView.Engine.live_to_iodata(
  #                           {:safe,
  #                            Phoenix.LiveView.HTMLEngine.empty_attribute_encode(
  #                              "left: #{x}px; top: #{y}px"
  #                            )}
  #                         )

  #                       [v0]
  #                     end,
  #                   fingerprint: 336_789_727_882_271_503_443_163_804_082_402_674_915
  #                 },
  #                 for
  #               )

  #             false ->
  #               nil
  #           end

  #         [v1]
  #       end

  #       %Phoenix.LiveView.Rendered{
  #         static: ["<div>\n  ", "\n</div>"],
  #         dynamic: dynamic,
  #         fingerprint: 160_972_604_617_627_664_978_915_242_075_956_727_828,
  #         root: true
  #       }
  #     )
  #   )
  # end

  @impl true
  def render(assigns) do
    # static data
    tiles = TileData.tiles()

    # builds the data and is the real comparison to other JS frameworks
    # tiles = build_tiles(0, 0, [])
    assigns = assign(assigns, :tiles, tiles)
    ~Z"""
    <div>
      <%= for [x, y] <- @tiles do %>
        <div class="tile" foo={} style="left: 123px; top: 456: 456px"></div>
      <% end %>
    </div>
    """
  end

  def build_tiles(radius, angle, tiles) when radius < @max do
    x = @center_x + :math.cos(angle) * radius
    y = @center_y + :math.sin(angle) * radius

    tiles = if (x >= 0 && x <= @wrapper_width - @cell_size && y >= 0 && y <= @wrapper_height - @cell_size) do
      [[ :erlang.float_to_binary(x, decimals: 2), :erlang.float_to_binary(y, decimals: 2) ] | tiles]
    else
      tiles
    end

    angle = angle + 0.2
    radius = radius + @step

    build_tiles(radius, angle, tiles)
  end

  def build_tiles(_radius, _angle, tiles),
    do: tiles
end
