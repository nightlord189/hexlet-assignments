# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def test_push
    stack = Stack.new
    [1,2,3].each do |i|
      stack.push!(i)
    end

    assert_equal stack.to_a, [1,2,3]
  end

  def test_pop
    stack = Stack.new
    [1,2,3].each do |i|
      stack.push!(i)
    end

    out = stack.pop!
    assert_equal out, 3

    assert_equal stack.size, 2
  end

  def test_clear
    stack = Stack.new
    [1,2,3].each do |i|
      stack.push!(i)
    end

    stack.clear!
    assert_equal stack.size, 0
    assert_empty stack.to_a
  end

  def test_empty
    stack = Stack.new
    assert stack.empty?

    stack.push!(1)

    refute stack.empty?

    stack.pop!
    assert stack.empty?
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
