# frozen_string_literal: true

# BEGIN
module Model
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attribute(name, options = {})
      @default_values ||= {}
      @default_values[name] = options[:default]

      puts "attribute, name: #{name}, options: #{options}, default_values: #{@default_values}"

      define_method name do
        puts "getter #{name}"

        if self.instance_variable_defined?("@#{name}")
          value = self.instance_variable_get "@#{name}"
          puts "instance_variable #{name} is defined, returning #{value}"
          return value
        end

        return options.fetch(:default, nil)
      end

      define_method "#{name}=" do |value|
        puts "setter #{name}=#{value}"
        self.instance_variable_set "@#{name}", transform_value(value, options[:type])
      end
    end

    def default_values
      @default_values
    end
  end

  def initialize(attrs = {})
    puts "initialize, attrs: #{attrs}, default_values: #{self.class.default_values}"
    attrs.each do |key, value|
      send("#{key}=",value)
    end
  end

  def attributes
    result = {}
    instance_variables.each do |var|
      key = var.to_s.sub('@', '').to_sym
      result[key] = instance_variable_get(var)
      puts "#{var}: #{instance_variable_get(var)}"
    end

    self.class.default_values.each do |key, value|
      unless result.key?(key)
        result[key] = value
      end
    end

    puts "attributes, result: #{result}, default_values: #{self.class.default_values}"

    result
  end

  def transform_value(val, type)
    if val == nil
      return val
    end

    case type
    when :string
      val.to_s
    when :integer
      val.to_i
    when :boolean
      !!val
    when :datetime
      DateTime.parse(val)
    else
      val
    end
  end
end
# END
