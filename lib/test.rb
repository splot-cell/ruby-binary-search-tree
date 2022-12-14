# frozen_string_literal: true

require_relative "binary_search_tree"

# This test file was used during development to drive the Tree class and ensure
# functions behaved as expected. It is not a test suite.

data = []
20.times { data << rand(20) }

tree = Tree.new(data)
tree.pretty_print

tree.insert(20)
tree.pretty_print
tree.insert(21)
tree.pretty_print
# puts tree.balanced?

tree.delete(20)
tree.pretty_print
# puts tree.balanced?
tree.delete(9)
tree.delete(10)
tree.delete(11)
tree.pretty_print

puts tree.balanced?
tree.rebalance
tree.pretty_print
puts tree.balanced?

# puts tree.find(9).to_s
# puts tree.find(12).to_s

# pp tree.level_order
# pp tree.level_order { |node| puts node.to_s }

# pp tree.level_order_rec
# pp tree.level_order_rec { |node| puts node.to_s }

# pp tree.inorder
# pp tree.inorder { |node| puts node.to_s }

# pp tree.preorder
# pp tree.preorder { |node| puts node.to_s }

# pp tree.postorder
# pp tree.postorder { |node| puts node.to_s }

# puts tree.height(tree.find(12))
# puts tree.depth(tree.find(12))
# puts tree.depth(tree.find(19))
