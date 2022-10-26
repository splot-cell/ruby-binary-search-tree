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

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    return node if value == node.data

    if value < node.data
      node.left_child = insert(value, node.left_child)
    else
      node.right_child = insert(value, node.right_child)
    end
    node
  end

  def delete(value)
    @root = delete_node(value)
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

  def find(value, node = @root)
    return if node.nil?

    return node if value == node.data

    return find(value, node.left_child) if value < node.data

    find(value, node.right_child)
  end

  def level_order
    queue = []
    values = []
    current_node = @root
    until current_node.nil?
      queue << current_node.left_child unless current_node.left_child.nil?
      queue << current_node.right_child unless current_node.right_child.nil?
      block_given? ? yield(current_node) : values << current_node.data
      current_node = queue.shift
    end
    values unless block_given?
  end

  def level_order_rec(queue = [@root], &block)
    return [] if queue.empty?

    values = []
    current_node = queue.shift
    values << traverse(current_node, &block)

    queue << current_node.left_child unless current_node.left_child.nil?
    queue << current_node.right_child unless current_node.right_child.nil?

    values << level_order_rec(queue, &block)
    values.flatten unless block_given?
  end

  def inorder(node = @root, &block)
    return if node.nil?

    values = []
    values << inorder(node.left_child, &block) unless node.left_child.nil?
    values << traverse(node, &block)
    values << inorder(node.right_child, &block) unless node.right_child.nil?
    return values.flatten unless block_given?
  end

  private

  def traverse(node, &block)
    block_given? ? block.call(node) : node.data
  end

  def delete_node(value, node = @root)
    return if node.nil?

    if value < node.data
      node.left_child = delete_node(value, node.left_child)
    elsif value > node.data
      node.right_child = delete_node(value, node.right_child)
    else
      # If current node has zero children, or only a right child
      return node.right_child if node.left_child.nil?

      # If current node has only a left child
      return node.left_child if node.right_child.nil?

      # If current node has 2 children
      root_replacement = node.right_child.lowest_child_recur
      # Only replacing the data in node with that of the node to be
      # deleted saves replacing left_child and right_child (i.e. saves one
      # assignment) vs actually moving the Node object up the Tree
      node.data = root_replacement.data
      node.right_child = delete_node(root_replacement.data, node.right_child)
    end
    node
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

  def to_s
    "Node with data: #{@data}"
  end
end
