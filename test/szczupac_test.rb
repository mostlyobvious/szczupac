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

  def data_types
    %w[binary json]
  end

  def database_urls
    %w[sqlite postgres mysql]
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
      Szczupac[ruby: rubies, gemfile: gemfiles, data_type: data_types],
      [
        { ruby: "3.2", gemfile: "Gemfile", data_type: "binary" },
        { ruby: "3.1", gemfile: "Gemfile", data_type: "binary" },
        { ruby: "3.0", gemfile: "Gemfile", data_type: "binary" },
        { ruby: "3.2", gemfile: "Gemfile.rails_6_1", data_type: "binary" },
        { ruby: "3.2", gemfile: "Gemfile", data_type: "json" }
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
        Szczupac.axis(:gemfile, gemfiles)
      ),
      [
        { ruby: "3.2", gemfile: "Gemfile" },
        { ruby: "3.1", gemfile: "Gemfile" },
        { ruby: "3.0", gemfile: "Gemfile" },
        { ruby: "3.2", gemfile: "Gemfile.rails_6_1" }
      ]
    )
  end

  def test_permuations
    assert_equal(
      Szczupac.permutation(
        Szczupac.axis(:database_url, database_urls),
        Szczupac.axis(:data_type, data_types)
      ),
      [
        { database_url: "sqlite", data_type: "binary" },
        { database_url: "sqlite", data_type: "json" },
        { database_url: "postgres", data_type: "binary" },
        { database_url: "postgres", data_type: "json" },
        { database_url: "mysql", data_type: "binary" },
        { database_url: "mysql", data_type: "json" }
      ]
    )
  end

  def test_generate_mixed_database_urls
    assert_equal(
      Szczupac.generate(
        Szczupac.axis(:ruby, rubies),
        Szczupac.axis(:gemfile, %w[Gemfile]),
        Szczupac.permutation(
          Szczupac.axis(:database_url, database_urls),
          Szczupac.axis(:data_type, data_types)
        )
      ),
      [
        {
          ruby: "3.2",
          gemfile: "Gemfile",
          database_url: "sqlite",
          data_type: "binary"
        },
        {
          ruby: "3.1",
          gemfile: "Gemfile",
          database_url: "sqlite",
          data_type: "binary"
        },
        {
          ruby: "3.0",
          gemfile: "Gemfile",
          database_url: "sqlite",
          data_type: "binary"
        },
        {
          ruby: "3.2",
          gemfile: "Gemfile",
          database_url: "sqlite",
          data_type: "json"
        },
        {
          ruby: "3.2",
          gemfile: "Gemfile",
          database_url: "postgres",
          data_type: "binary"
        },
        {
          ruby: "3.2",
          gemfile: "Gemfile",
          database_url: "postgres",
          data_type: "json"
        },
        {
          ruby: "3.2",
          gemfile: "Gemfile",
          database_url: "mysql",
          data_type: "binary"
        },
        {
          ruby: "3.2",
          gemfile: "Gemfile",
          database_url: "mysql",
          data_type: "json"
        }
      ]
    )
  end

  def test_generate_always_return_keys_ordered_as_the_input
    assert_equal(
      Szczupac.generate(
        Szczupac.axis(:ruby, rubies),
        Szczupac.axis(:gemfile, gemfiles)
      ).map(&:keys),
      [%i[ruby gemfile]] * 4
    )
  end

  def test_permutation_always_return_keys_ordered_as_the_input
    assert_equal(
      Szczupac.permutation(
        Szczupac.axis(:database_url, database_urls),
        Szczupac.axis(:data_type, data_types)
      ).map(&:keys),
      [%i[database_url data_type]] * 6
    )
  end

  def test_combining
    assert_equal(
      [
        *Szczupac.generate(
          Szczupac.axis(:database_url, %w[sqlite]),
          Szczupac.axis(:data_type, %w[binary])
        ),
        *Szczupac.generate(
          Szczupac.axis(:database_url, %w[postgres_12 postgres_11]),
          Szczupac.axis(:data_type, %w[binary json jsonb])
        ),
        *Szczupac.generate(
          Szczupac.axis(:database_url, %w[mysql_8 mysql_5]),
          Szczupac.axis(:data_type, %w[binary json])
        )
      ],
      [
        { database_url: "sqlite", data_type: "binary" },
        { database_url: "postgres_12", data_type: "binary" },
        { database_url: "postgres_11", data_type: "binary" },
        { database_url: "postgres_12", data_type: "json" },
        { database_url: "postgres_12", data_type: "jsonb" },
        { database_url: "mysql_8", data_type: "binary" },
        { database_url: "mysql_5", data_type: "binary" },
        { database_url: "mysql_8", data_type: "json" }
      ]
    )
  end
end
