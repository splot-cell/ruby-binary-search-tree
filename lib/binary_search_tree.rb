# frozen_string_literal: true

class Tree
  attr_accessor :root

  def initialize(arr)
    root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr)

  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child,
                 "#{prefix}#{is_left ? '│   ' : '    '}",
                 false)
                 if node.right_child

    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"

    pretty_print(node.left_child,
                 "#{prefix}#{is_left ? '    ' : '│   '}",
                true)
                if node.left_child
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
