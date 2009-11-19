# encoding: utf-8

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

hook do |generator, context|
  rm "setup.rb" unless context[:setup_hook]
  rm "postprocess.rb" unless context[:postprocess_hook]
end
