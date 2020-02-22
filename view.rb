class View
  def initialize(drawer)
    @drawer = drawer
  end

  def draw_grid(w, h)
    color = [60, 60, 60]

    # tate
    (1..w).each { |x|
      @drawer.draw_line(x, 0, x, h, color)
    }

    # yoko
    (1..h).each { |y|
      @drawer.draw_line(0, y, w, y, color)
    }
  end

  def draw_plus_pole(pole)
    @drawer.draw_box(
      pole.x + 0.1, pole.y + 0.1,
      pole.x + 0.9, pole.y + 0.9,
      C_WHITE
    )
    @drawer.draw_line(
      pole.x + 0.3, pole.y + 0.5,
      pole.x + 0.7, pole.y + 0.5,
      C_WHITE
    )
    @drawer.draw_line(
      pole.x + 0.5, pole.y + 0.3,
      pole.x + 0.5, pole.y + 0.7,
      C_WHITE
    )
  end

  def draw_minus_pole(pole)
    @drawer.draw_box(
      pole.x + 0.1, pole.y + 0.1,
      pole.x + 0.9, pole.y + 0.9,
      C_WHITE
    )
    @drawer.draw_line(
      pole.x + 0.3, pole.y + 0.5,
      pole.x + 0.7, pole.y + 0.5,
      C_WHITE
    )
  end

end
