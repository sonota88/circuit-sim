def browser?
  Kernel.const_defined?(:Native)
end

if browser?
  require "dxopal"
else
  require "./dxopal_sdl"
end

include DXOpal

require_remote "./data.rb"
require_remote "./circuit.rb"
require_remote "./view.rb"

# pixels per cell
PPC = 30

def parse_json(json)
  if browser?
    Native(`JSON.parse(json)`)
  else
    require "json"
    JSON.parse(json)
  end
end

def hide_loading
  %x{
    var loadingContainer = document.querySelector(".loading_container");
    loadingContainer.style.display = "none";
  }
end

def on_push_switch(pushed_switch)
  Sound[:click].play
  pushed_switch.toggle()
end

def main_loop(circuit, view)
  switch_changed = false

  mx = (Input.mouse_x / PPC).floor
  my = (Input.mouse_y / PPC).floor

  if Input.mouse_push?(M_LBUTTON)
    mpos = Point(mx, my)

    pushed_switch =
      circuit.find_switch_by_position(mpos)

    if pushed_switch
      on_push_switch(pushed_switch)
      switch_changed = true
    end
  end

  tx = (Input.touch_x / PPC).floor
  ty = (Input.touch_y / PPC).floor

  if Input.touch_push?
    tpos = Point(tx, ty)

    pushed_switch =
      circuit.find_switch_by_position(tpos)

    if pushed_switch
      on_push_switch(pushed_switch)
      switch_changed = true
    end
  end

  if switch_changed
    circuit.update_tuden_state()
    circuit.update_lamps_state()
  end

  view.draw_grid(11, 11)

  circuit.child_circuits.each { |child_circuit|
    child_circuit.edges.each { |edge|
      view.draw_edge(edge)
    }

    child_circuit.plus_poles.each { |pole|
      view.draw_plus_pole(pole)
    }

    child_circuit.minus_poles.each { |pole|
      view.draw_minus_pole(pole)
    }

    child_circuit.switches.each { |switch|
      view.draw_switch(switch)
    }

    child_circuit.lamps.each { |lamp|
      view.draw_lamp(lamp)
    }
  }

  view.draw_cursor_highlight(mx, my)
end

# --------------------------------

circuit = Circuit.from_plain(parse_json($data_json))
circuit.update_tuden_state()
circuit.update_lamps_state()

view = View.new(PPC)

Sound.register(:click, "click.wav")

Window.load_resources do
  hide_loading()

  Window.bgcolor = C_BLACK

  Window.loop do
    main_loop(circuit, view)
  end
end
