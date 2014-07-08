require 'java'
require 'activemq'

# Class to subscribe to an ActiveMQ topic and present the messages nicely
class ActiveMQProducer

  # :call-seq:
  #   ActiveMQProducer.new(connection_string: "tcp://localhost:61616", queue: "some-queue")   -> Queue producer
  #   ActiveMQProducer.new(connection_string: "tcp://localhost:61616", topic: "some-topic")   -> Topic producer
  def initialize(hash)
    @messages = []
    @connection_string = hash[:connection_string]
    @connection_factory = Java::OrgApacheActivemq::ActiveMQConnectionFactory.new(@connection_string)
    @connection = @connection_factory.create_connection
    @session = @connection.create_session(false, Java::JavaxJms::Session::AUTO_ACKNOWLEDGE)
    if hash[:topic]
      topic = Java::OrgApacheActivemqCommand::ActiveMQTopic.new hash[:topic]
      destination = @session.createTopic topic
    end
    if hash[:queue]
      queue = Java::OrgApacheActivemqCommand::ActiveMQQueue.new hash[:queue]
      destination = @session.createQueue queue
    end
    @producer = @session.createProducer destination
    @connection.start
  end

  def send_text_message(string)
    message = @session.create_text_message
    message.set_text = string
    @producer.send message
  end

  # :call-seq:
  #    producer.send([1,2,3])
  #    producer.send(Java::byte[3].new)
  def send_bytes_message(array)
    bytes = array
    bytes = array.pack('C*').to_java_bytes if array.is_a?(Array)
    message = @session.create_bytes_message
    message.set_bytes = bytes
    @producer.send message
  end

  def close
    @subscriber.stop
    @subscriber.close
    @session.stop
    @session.close
    @connection.stop
    @connection.close
  end

end
