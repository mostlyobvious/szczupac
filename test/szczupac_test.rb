require "minitest/autorun"
require_relative "../lib/szczupac"

class SzczupacTest < Minitest::Test
  def rubies
    %w[3.2 3.1 3.0]
  end

  def gemfiles
    %w[Gemfile Gemfile.rails_6_1]
  end

  def test_generates_viable_combinations_from_two
    assert_equal(
      Szczupac.call(ruby: rubies, gemfile: gemfiles),
      [
        { ruby: "3.2", gemfile: "Gemfile" },
        { ruby: "3.1", gemfile: "Gemfile" },
        { ruby: "3.0", gemfile: "Gemfile" },
        { ruby: "3.2", gemfile: "Gemfile.rails_6_1" }
      ]
    )
  end
end
