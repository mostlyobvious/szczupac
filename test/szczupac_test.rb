require "minitest/autorun"
require_relative "../lib/szczupac"


Minitest::Test.make_my_diffs_pretty!

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
      Szczupac[ruby: rubies, gemfile: gemfiles],
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
      Szczupac[ruby: rubies, gemfile: gemfiles, data_type: data_type],
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
      [{ ruby: "3.2", gemfile: "Gemfile" }]
    )
  end

  def test_always_return_keys_ordered_as_the_input
    axes = { ruby: rubies, gemfile: gemfiles }
    assert_equal(Szczupac[**axes].map(&:keys), [axes.keys] * 4)
  end

  def test_axis_as_symbol
    assert_equal(
      Szczupac.axis(:ruby, rubies),
      [{ ruby: "3.2" }, { ruby: "3.1" }, { ruby: "3.0" }]
    )
  end

  def test_axis_as_string
    assert_equal(
      Szczupac.axis("ruby", rubies),
      [{ "ruby" => "3.2" }, { "ruby" => "3.1" }, { "ruby" => "3.0" }]
    )
  end

  def test_generate_from_axes
    assert_equal(
      Szczupac.generate(
        Szczupac.axis(:ruby, rubies),
        Szczupac.axis(:gemfile, gemfiles),
      ),
      [
        { ruby: "3.2", gemfile: "Gemfile" },
        { ruby: "3.1", gemfile: "Gemfile" },
        { ruby: "3.0", gemfile: "Gemfile" },
        { ruby: "3.2", gemfile: "Gemfile.rails_6_1" }
      ]
    )

  end
end
