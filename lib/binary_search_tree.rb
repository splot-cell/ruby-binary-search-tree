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

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right_child,
                 "#{prefix}#{is_left ? '│   ' : '    '}",
                 false) if node.right_child

    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"

    pretty_print(node.left_child,
                 "#{prefix}#{is_left ? '    ' : '│   '}",
                true) if node.left_child
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
end
