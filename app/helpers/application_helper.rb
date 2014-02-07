module ApplicationHelper
  def direction_to_color(direction)
    case direction
      when '+'
        'green'
      when '-'
        'red'
      else
        'black'
    end
  end
end
