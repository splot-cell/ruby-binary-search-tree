# frozen_string_literal: true

require_relative "./lib/binary_search_tree"

data = []
100.times { data << rand(100) }

tree = Tree.new(data)
# tree.pretty_print
