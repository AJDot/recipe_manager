# useful for assigning a global context to a model, usable in callbacks
module Contextable
  def contexts
    @contexts ||= {}
  end

  def contexts=(context_hash)
    raise ArgumentError.new("Contexts must be a hash.") unless context_hash.is_a?(Hash) || context_hash.nil?
    @contexts = context_hash
  end

  def context_dig(path)
    case path
    when String
      keys = path.split('.').map(&:to_sym)
    when Symbol
      keys = [path]
    else
      return nil
    end
    contexts.dig(*keys)
  end

  # set a context on the object
  #   if a block is given, remove that context after yielding to the block
  # @overload with_context(context)
  #   @param context [Hash] contexts to merge with current context
  # @overload with_context(context)
  #   @param context [Symbol, String] context to set to true
  # @return [self] so methods can be chained
  def with_context(context)
    if context.is_a?(Hash)
      contexts.merge!(context)
    else
      contexts[context] = true
      @current_context = context
    end
    # makes sure context is only present for this block
    if block_given?
      yield
      if context.is_a?(Hash)
        contexts.delete(*context.keys)
      else
        contexts.delete(@current_context)
      end
    end
    self
  end

  # @example custom after_save callbacks
  #   contexts = { after_save: ->(model) { model.do_something } }
  #   push_context({ after_save: ->() { model.do_something_else } })
  #     context == { after_save: [->(model) { model.do_something }, ->() { model.do_something_else }] }
  def push_context(context)
    context.each do |k, v|
      contexts[k] = Array(contexts[k]) + Array(v)
    end
  end

  # @example with no value given
  #   context?(:thing) # checks if contexts[:thing].present?
  #   # remember that false.present? and nil.present? return false
  # @example with value given
  #   context?(:thing, 'ABC') # checks that the value contexts[:thing] is equal to 'ABC'
  def context?(context_key, value = nil)
    context = contexts[context_key]
    if value.nil?
      context.present?
    else
      context == value
    end
  end

  def reset_context
    @contexts = {}
  end
end