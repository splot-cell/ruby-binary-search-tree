# frozen_string_literal: true

class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr)
    return if arr.empty?

    mid_i = (arr.length - 1) / 2

    tree_root = Node.new(arr[mid_i])
    tree_root.left_child = build_tree(arr[0...mid_i])
    tree_root.right_child = build_tree(arr[mid_i + 1..])
    tree_root
  end

  def insert(value, current_node = @root)
    return Node.new(value) if current_node.nil?

    return current_node if value == current_node.data

    if value < current_node.data
      current_node.left_child = insert(value, current_node.left_child)
    else
      current_node.right_child = insert(value, current_node.right_child)
    end
    current_node
  end

  def delete(value, current_node = @root)
    return if current_node.nil?

    if value < current_node.data
      current_node.left_child = delete(value, current_node.left_child)
    elsif value > current_node.data
      current_node.right_child = delete(value, current_node.right_child)
    else
      # If current node has zero children, or only a right child
      return current_node.right_child if current_node.left_child.nil?

      # If current node has only a left child
      return current_node.left_child if current_node.right_child.nil?

      # If current node has 2 children
      root_replacement = current_node.right_child.lowest_child_recur
      # Only replacing the data in current_node with that of the node to be
      # deleted saves replacing left_child and right_child (i.e. saves one
      # assignment) vs actually moving the Node object up the Tree
      current_node.data = root_replacement.data
      current_node.right_child = delete(root_replacement.data,
                                        current_node.right_child)
    end
    current_node
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    if node.right_child
      pretty_print(node.right_child,
                   "#{prefix}#{is_left ? '│   ' : '    '}",
                   false)
    end
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    return unless node.left_child

    pretty_print(node.left_child,
                 "#{prefix}#{is_left ? '    ' : '│   '}",
                 true)
  end
end

class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def initialize(value)
    @data = value
    left_child = nil
    right_child = nil
  end

  def <=>(other)
    @data <=> other.data
  end

  def num_children
    n = 0
    n += 1 unless left_child.nil?
    n += 1 unless right_child.nil?
    n
  end

  def lowest_child_recur
    return self if left_child.nil?

    left_child.lowest_child_recur
  end
end
