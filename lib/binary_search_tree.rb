# frozen_string_literal: true

class Tree
  attr_accessor :root

  def initialize(arr)
    root = build_tree(arr.sort)
  end

  def build_tree(arr)

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
