#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Reverse of goto_rswag.rb: given a zenpayroll rswag spec file (under
# .../spec/requests/rswag/v<version>/...) and a 1-indexed cursor line, find
# the enclosing operation's operationId and print the Gusto-Partner-API
# src/api.v<version>.yaml file/line that defines the matching operation.
#
# Usage: ruby goto_oas.rb <path/to/rswag/v<version>/..._spec.rb> <line>
#
# On success prints two lines to stdout: the OAS file's absolute path, then
# the 1-indexed line number of its `operationId: <id>` line.
# On failure prints a message to stderr and exits non-zero.

require "psych"

file = ARGV[0]
cursor_line = ARGV[1].to_i

version = file[%r{/rswag/v(\d{4}-\d{2}-\d{2})(?:/|$)}, 1]
abort("Not inside a spec/requests/rswag/v<version>/ file: #{file}") unless version

def find_repo_root(start_dir)
  dir = start_dir
  loop do
    return dir if File.exist?(File.join(dir, ".git"))
    parent = File.dirname(dir)
    return nil if parent == dir
    dir = parent
  end
end

zp_root = find_repo_root(File.dirname(file))
abort("Could not find repo root (no .git found above #{file})") unless zp_root

HTTP_METHODS = %i[get put post delete options head patch trace].freeze

def each_node(node, &blk)
  return unless node.is_a?(RubyVM::AbstractSyntaxTree::Node)

  blk.call(node)
  node.children.each { |c| each_node(c, &blk) if c.is_a?(RubyVM::AbstractSyntaxTree::Node) }
end

def find_method_blocks(node, acc = [])
  return acc unless node.is_a?(RubyVM::AbstractSyntaxTree::Node)

  if node.type == :ITER
    call_node = node.children[0]
    if call_node.is_a?(RubyVM::AbstractSyntaxTree::Node)
      mid = call_node.children.find { |c| c.is_a?(Symbol) }
      acc << node if HTTP_METHODS.include?(mid)
    end
  end
  node.children.each { |c| find_method_blocks(c, acc) if c.is_a?(RubyVM::AbstractSyntaxTree::Node) }
  acc
end

def find_operation_id(node)
  result = nil
  each_node(node) do |n|
    next unless n.type == :FCALL
    next unless n.children[0] == :operationId

    str_node = nil
    each_node(n.children[1]) { |m| str_node = m if m.type == :STR }
    result = str_node.children[0] if str_node
  end
  result
end

ast = RubyVM::AbstractSyntaxTree.parse(File.read(file), keep_script_lines: true)
candidates = find_method_blocks(ast).select { |n| cursor_line.between?(n.first_lineno, n.last_lineno) }
abort("No operation found at line #{cursor_line}. Place the cursor inside a get/post/put/patch/delete block.") if candidates.empty?

op_node = candidates.min_by { |n| n.last_lineno - n.first_lineno }
operation_id = find_operation_id(op_node)
abort("No operationId found for the block at line #{cursor_line}") unless operation_id

workspace = ENV["WORKSPACE"]
repo_candidates = []
repo_candidates << File.join(workspace, "Gusto-Partner-API") if workspace && !workspace.empty?
repo_candidates << File.expand_path(File.join(zp_root, "..", "Gusto-Partner-API"))
oas_repo = repo_candidates.find { |d| File.directory?(d) }
abort("Could not find Gusto-Partner-API checkout. Tried: #{repo_candidates.join(", ")}") unless oas_repo

oas_file = File.join(oas_repo, "src", "api.v#{version}.yaml")
abort("No OAS file found at #{oas_file}") unless File.exist?(oas_file)

def mapping_pairs(node)
  return [] unless node.is_a?(Psych::Nodes::Mapping)

  node.children.each_slice(2).to_a
end

def mapping_value(node, key)
  mapping_pairs(node).each { |k, v| return v if k.value == key }
  nil
end

doc = Psych.parse_file(oas_file)
paths_node = mapping_value(doc.root, "paths")
abort("No paths key found in #{oas_file}") unless paths_node

target_line = nil
mapping_pairs(paths_node).each do |_path_key, path_item|
  next unless path_item.is_a?(Psych::Nodes::Mapping)

  mapping_pairs(path_item).each do |method_key, candidate_op|
    next unless HTTP_METHODS.map(&:to_s).include?(method_key.value)
    next unless candidate_op.is_a?(Psych::Nodes::Mapping)

    op_id_node = mapping_value(candidate_op, "operationId")
    next unless op_id_node && op_id_node.value == operation_id

    target_line = op_id_node.start_line + 1
  end
end

abort("No matching operationId '#{operation_id}' found in #{oas_file} (has the aggregator run yet?)") unless target_line

puts oas_file
puts target_line
