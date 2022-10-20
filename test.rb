# frozen_string_literal: true

require_relative "./lib/binary_search_tree"

data = []
20.times { data << rand(20) }

tree = Tree.new(data)
tree.pretty_print

tree.insert(20)
tree.pretty_print
tree.insert(15)
tree.pretty_print

tree.delete(20)
tree.pretty_print
tree.delete(9)
tree.delete(10)
tree.delete(11)
tree.pretty_print
