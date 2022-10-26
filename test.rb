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

puts tree.find(9).to_s
puts tree.find(12).to_s

pp tree.level_order
tree.level_order { |node| puts node.to_s }

pp tree.level_order_rec
tree.level_order_rec { |node| puts node.to_s }
