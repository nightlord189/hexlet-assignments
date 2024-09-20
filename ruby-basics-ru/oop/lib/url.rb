# frozen_string_literal: true

# BEGIN
require 'uri'
require 'forwardable'

class Url
  extend Forwardable
  include Comparable

  def <=>(other)
    [host, port, scheme, query_params] <=> [other.host, other.port, other.scheme, other.query_params]
  end

  def initialize(url)
    @url_raw = url
    @internal = URI(@url_raw)
  end

  def_delegators :@internal, :host, :port, :scheme

  def query_params
    raw_query = @internal.query
    result = {}

    if raw_query.nil?
      return result
    end
    splitted = raw_query.split('&')

    splitted.each do |pair|
      key, value = pair.split('=')
      result[key.to_sym] = value
    end
    result
  end

  def query_param(key, default=nil)
    params = query_params
    params.fetch(key, default)
  end
end
# END
