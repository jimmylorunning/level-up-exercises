# Killer facts about triangles AWW YEAH
class Triangle
  attr_accessor :side1, :side2, :side3

  EQUILATERAL_STR = 'This triangle is equilateral!'
  ISOSCELES_STR = 'This triangle is isoceles! Also, that word is hard to type.'
  SCALENE_STR = 'This triangle is scalene and mathematically boring.'

  def initialize(side1, side2, side3)
    @side1, @side2, @side3 = side1, side2, side3
  end

  def equilateral
    side1 == side2 && side2 == side3
  end

  def isosceles
    [side1, side2, side3].uniq.length == 2
  end

  def scalene
    if equilateral || isosceles
      false
    else
      true
    end
  end

  def recite_facts
    recite_triangle_type
    recite_angles
    recite_right_triangle
    puts ''
  end

  def recite_triangle_type
    puts EQUILATERAL_STR if equilateral
    puts ISOCELES_STR if isosceles
    puts SCALENE_STR if scalene
  end

  def recite_angles
    puts 'The angles of this triangle are ' + recite_angles_helper
  end

  def recite_angles_helper
    angles.join(',')
  end

  def angles
    calculate_angles(side1, side2, side3)
  end

  def recite_right_triangle
    puts 'This triangle is also a right triangle!' if angles.include? 90
  end

  def calculate_angles(a, b, c)
    angle_a = calculate_angle(a, b, c)
    angle_b = calculate_angle(b, a, c)
    angle_c = calculate_angle(c, a, b)

    [angle_a, angle_b, angle_c]
  end

  def calculate_angle(a, b, c)
    radians_to_degrees((b**2 + c**2 - a**2) / (2.0 * b * c))
  end

  def radians_to_degrees(rads)
    (rads * 180 / Math::PI).round
  end
end

triangles = [
  [5, 5, 5],
  [5, 12, 13],
]
triangles.each do |sides|
  tri = Triangle.new(*sides)
  tri.recite_facts
end
