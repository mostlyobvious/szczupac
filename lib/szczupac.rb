# frozen_string_literal: true

require_relative "szczupac/version"

module Szczupac
  def call(**named_lanes)
    named_lanes
      .flat_map do |name, values|
        first_from_rest =
          named_lanes
            .reject { |n, _| n == name }
            .map { |n, v| { n => v.first } }
            .reduce(&:merge)
        values
          .map { |v| { name => v } }
          .product([first_from_rest])
          .map { |v| v.reduce(&:merge) }
      end
      .uniq
  end
  module_function :call
end
