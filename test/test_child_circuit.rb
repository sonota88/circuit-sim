# coding: utf-8

require "minitest/autorun"

require_relative "../child_circuit"

class TestChildCircuit < Minitest::Test
  def create_edges(*args)
    args.map { |xy1, xy2|
      Unit::Edge.new(
        Point(*xy1),
        Point(*xy2),
        []
      )
    }
  end

  def to_edge_groups(edges)
    ChildCircuit.to_edge_groups(edges)
  end

  # エッジが1本だけ
  def test_to_edge_groups_1
    edges = create_edges(
      [[1, 1], [2, 1]]
    )

    groups = to_edge_groups(edges)

    assert_equal(1, groups.size)
  end

  # エッジが複数、マージあり
  def test_to_edge_groups_2
    edges = create_edges(
      [[ 1, 1], [ 2, 1]],
      [[ 1, 1], [ 1, 2]],
      [[10, 1], [10, 2]]
    )

    groups = to_edge_groups(edges)

    assert_equal(2, groups.size)
  end

  # エッジが複数、マージなし
  def test_to_edge_groups_3
    edges = create_edges(
      [[ 1, 1], [ 1, 2]],
      [[10, 1], [10, 2]],
      [[20, 1], [20, 2]]
    )

    groups = to_edge_groups(edges)

    assert_equal(3, groups.size)
  end
end
