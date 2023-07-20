require "minitest/autorun"
require_relative "../lib/szczupac"

class SzczupacTest < Minitest::Test
  def rubies
    %w[3.2 3.1 3.0]
  end

  def gemfiles
    %w[Gemfile Gemfile.rails_6_1]
  end

  def data_type
    %w[jsonb json binary]
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

  def test_generates_viable_combinations_from_three
    assert_equal(
      Szczupac.call(ruby: rubies, gemfile: gemfiles, data_type: data_type),
      [
        { ruby: "3.2", gemfile: "Gemfile", data_type: "jsonb" },
        { ruby: "3.1", gemfile: "Gemfile", data_type: "jsonb" },
        { ruby: "3.0", gemfile: "Gemfile", data_type: "jsonb" },
        { ruby: "3.2", gemfile: "Gemfile.rails_6_1", data_type: "jsonb" },
        { ruby: "3.2", gemfile: "Gemfile", data_type: "json" },
        { ruby: "3.2", gemfile: "Gemfile", data_type: "binary" }
      ]
    )
  end

  def test_responds_to_square_brackets
    assert_equal(
      Szczupac[ruby: rubies.take(1), gemfile: gemfiles.take(1)],
      [
        { ruby: "3.2", gemfile: "Gemfile" }
      ]
    )
  end
end
