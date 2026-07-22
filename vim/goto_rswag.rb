#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Given a Gusto-Partner-API src/api.v<version>.yaml file and a 1-indexed
# cursor line, find the enclosing operation's operationId and print the
# zenpayroll rswag spec file/line that defines it.
#
# Usage: ruby goto_rswag.rb <path/to/src/api.v<version>.yaml> <line>
#
# On success prints two lines to stdout: the rswag file's absolute path,
# then the 1-indexed line number of its `operationId '<id>'` line.
# On failure prints a message to stderr and exits non-zero.

require "psych"

file = ARGV[0]
cursor_line = ARGV[1].to_i

abort("Not inside a src/api.v*.yaml file: #{file}") unless file =~ /api\.v(\d{4}-\d{2}-\d{2})\.yaml\z/
version = $1

def find_repo_root(start_dir)
  dir = start_dir
  loop do
    return dir if File.exist?(File.join(dir, ".git"))
    parent = File.dirname(dir)
    return nil if parent == dir
    dir = parent
  end
end

repo_root = find_repo_root(File.dirname(file))
abort("Could not find repo root (no .git found above #{file})") unless repo_root

def mapping_pairs(node)
  return [] unless node.is_a?(Psych::Nodes::Mapping)
  node.children.each_slice(2).to_a
end

def mapping_value(node, key)
  mapping_pairs(node).each { |k, v| return v if k.value == key }
  nil
end

doc = Psych.parse_file(file)
root = doc.root
paths_node = mapping_value(root, "paths")
abort("No paths key found in #{file}") unless paths_node

http_methods = %w[get put post delete options head patch trace]

found_path = nil
found_method = nil
op_node = nil

mapping_pairs(paths_node).each do |path_key, path_item|
  next unless path_item.is_a?(Psych::Nodes::Mapping)
  mapping_pairs(path_item).each do |method_key, candidate_op|
    next unless http_methods.include?(method_key.value)
    next unless candidate_op.is_a?(Psych::Nodes::Mapping)
    lo = method_key.start_line + 1
    hi = candidate_op.end_line
    next unless cursor_line.between?(lo, hi)
    found_path = path_key.value
    found_method = method_key.value
    op_node = candidate_op
    break
  end
  break if op_node
end

abort("No operation found at line #{cursor_line}. Place the cursor inside a get/post/put/patch/delete block.") unless op_node

op_id_node = mapping_value(op_node, "operationId")
abort("No operationId found for #{found_method} #{found_path}") unless op_id_node

operation_id = op_id_node.value

workspace = ENV["WORKSPACE"]
candidates = []
candidates << File.join(workspace, "zenpayroll") if workspace && !workspace.empty?
candidates << File.expand_path(File.join(repo_root, "..", "zenpayroll"))
zp_dir = candidates.find { |d| File.directory?(d) }
abort("Could not find zenpayroll checkout. Tried: #{candidates.join(", ")}") unless zp_dir

version_dirs = Dir.glob(File.join(zp_dir, "**", "spec", "requests", "rswag", "v#{version}"))
abort("No rswag spec directory for version v#{version} found under #{zp_dir}") if version_dirs.empty?

pattern = /^\s*operationId\s+['"]#{Regexp.escape(operation_id)}['"]/
matches = []
version_dirs.each do |vdir|
  Dir.glob(File.join(vdir, "**", "*.rb")).sort.each do |rb_file|
    File.readlines(rb_file).each_with_index do |line, idx|
      matches << [rb_file, idx + 1] if line =~ pattern
    end
  end
end

abort("No rswag spec found with operationId #{operation_id} under #{version_dirs.join(", ")}") if matches.empty?

if matches.size > 1
  warn("Multiple rswag matches for operationId #{operation_id}: #{matches.map { |f, l| "#{f}:#{l}" }.join(", ")}")
end

target_file, target_line = matches.first
puts target_file
puts target_line
