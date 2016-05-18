# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require 'neography'

class LogStash::Outputs::Neo4j < LogStash::Outputs::Base

  config_name "neo4j"

  config :host, :validate => :string, :required => true, :default => "localhost"
  config :port, :validate => :number, :required => true, :default => "7474"
  config :username, :validate => :string, :required => false, :default => nil
  config :password, :validate => :string, :required => false, :default => nil
  config :debug, :validate => :boolean, :default => false

  RECONNECT_BACKOFF_SLEEP = 0.5

  public
  def register
    @logger.info "Registering"
    connect
  end

  public
  def receive(event)
    return unless output?(event)
    return if event == LogStash::SHUTDOWN
    @logger.info event.inspect

    begin

      verb = event["verb"]
      actor_id = event["actor"]["id"]
      preferred_username = event["actor"]["preferredUsername"]
      display_name = event["actor"]["displayName"]

      property_id = event["property_id"]
      property_tag = event["gnip"]["matching_rules"][0]["tag"]
      dma_id = event["dma_id"]
      gender = event["gender"]
      created_at = event["created_at"]

      stamp = DateTime.strptime(created_at, "%Y-%m-%dT%H:%M:%S").to_time.to_i

      user_node = @client.get_or_create_unique_node("username", "username", actor_id, {:display_name => display_name, :preferred_username => preferred_username, :username => actor_id})
      property_node = @client.get_or_create_unique_node("property_id", "property_id", property_id, {:property_id => property_id, :property_tag => property_tag})

      @client.add_label(user_node["metadata"]["id"].to_i,"Person")
      @client.add_label(property_node["metadata"]["id"].to_i,"Property")

      @client.create_unique_relationship("twitter", "property_id", "#{actor_id}-#{property_id}-#{stamp}", "twitted_about", user_node, property_node, {:created_at => DateTime.strptime(created_at, "%Y-%m-%dT%H:%M:%S").to_time, :dma_id => dma_id, :gender => gender})
      #@client.create_unique_relationship("twitter", "actor_id", actor_id, "twitted_by", property_node, user_node)

    rescue Exception => e
      @logger.error("Client write error, trying connect", :e => e, :backtrace => e.backtrace)
      sleep(RECONNECT_BACKOFF_SLEEP)
      connect
      retry
    end

  end

  private

  def connect

    @logger.info("Connecting to neo4j server.", :address => @host, :port => @port)

    begin
      if @username.nil?
        @client = Neography::Rest.new("http://#{@host}:#{@port}")
      else
        @client = Neography::Rest.new("http://#{@username}:#{@password}@#{@host}:#{@port}")
      end
    rescue Exception => e
      @logger.error("Host unavailable, sleeping", :host => @host, :e => e, :backtrace => e.backtrace)
      sleep(10)
      retry
    end
  end
end