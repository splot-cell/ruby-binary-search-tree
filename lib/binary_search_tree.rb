# frozen_string_literal: true

# Binary search tree class made up of Node objects
class Tree
  attr_accessor :root

  # Builds a balanced tree from an array
  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  # Builds a balanced tree from a sorted array
  def build_tree(arr)
    return if arr.empty?

    mid_i = (arr.length - 1) / 2

    tree_root = Node.new(arr[mid_i])
    tree_root.left_child = build_tree(arr[0...mid_i])
    tree_root.right_child = build_tree(arr[mid_i + 1..])
    tree_root
  end

  # node parameter is for recursive functionality only
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

  # Delete interface is separate from delete_node function to avoid bug when
  # delete is called on the value stored at @root.
  def delete(value)
    @root = delete_node(value)
  end

  # pretty_print provided by another learner at The Odin Project
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

  # node parameter is for recursive functionality only
  def find(value, node = @root)
    return if node.nil?

    return node if value == node.data

    return find(value, node.left_child) if value < node.data

    find(value, node.right_child)
  end

  # Tree traversal: breadth first
  def level_order(&block)
    queue = []
    values = []
    current_node = @root
    until current_node.nil?
      queue << current_node.left_child unless current_node.left_child.nil?
      queue << current_node.right_child unless current_node.right_child.nil?
      values << traverse(current_node, &block)
      current_node = queue.shift
    end
    values unless block_given?
  end

  # Tree traversal: breadth first, but through recursive implementation
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

  # Tree traversal: depth first <left child> <root> <right child>
  def inorder(node = @root, &block)
    return if node.nil?

    values = []
    values << inorder(node.left_child, &block) unless node.left_child.nil?
    values << traverse(node, &block)
    values << inorder(node.right_child, &block) unless node.right_child.nil?
    return values.flatten unless block_given?
  end

  # Tree traversal: depth first <root> <left_child> <right_child>
  def preorder(node = @root, &block)
    return if node.nil?

    values = []
    values << traverse(node, &block)
    values << preorder(node.left_child, &block) unless node.left_child.nil?
    values << preorder(node.right_child, &block) unless node.right_child.nil?
    return values.flatten unless block_given?
  end

  # Tree traversal: depth first <left_child> <right_child> <root>
  def postorder(node = @root, &block)
    return if node.nil?

    values = []
    values << postorder(node.left_child, &block) unless node.left_child.nil?
    values << postorder(node.right_child, &block) unless node.right_child.nil?
    values << traverse(node, &block)
    return values.flatten unless block_given?
  end

  # Height is number of edges in longest path from a node to a leaf node
  def height(node)
    # Guard against nil nodes and leaf nodes
    return if node.nil?

    return 0 if node.num_children.zero?

    # Find the max height of any children
    l_height = node.left_child.nil? ? 0 : height(node.left_child)
    r_height = node.right_child.nil? ? 0 : height(node.right_child)
    max = l_height > r_height ? l_height : r_height
    # Return the max height plus one
    max + 1
  end

  def depth(node, current_node = @root)
    return if current_node.nil? || node.nil?

    count = 0

    return count if node == current_node

    count += 1

    return count + depth(node, current_node.left_child) if node < current_node

    count + depth(node, current_node.right_child)
  end

  private

  # Helper function for handing traversal behaviour when no block given
  def traverse(node, &block)
    block_given? ? block.call(node) : node.data
  end

  # Recursive delete function, returns root of new tree after value is removed
  # node parameter is for recursive functionality only
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

# Basic class for storing an integer as part of a BST
class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def initialize(value)
    @data = value
    left_child = nil
    right_child = nil
  end

  # Makes nodes comparable to each other, as specified on the project assignment
  def <=>(other)
    @data <=> other.data
  end

  def num_children
    n = 0
    n += 1 unless left_child.nil?
    n += 1 unless right_child.nil?
    n
  end

  # Finds the "offspring" node with the lowest value. I.e. recursively finds the
  # child's child... with the lowest value
  def lowest_child_recur
    return self if left_child.nil?

    left_child.lowest_child_recur
  end

  def to_s
    "Node with data: #{@data}"
  end
end
