require 'java'
require 'jruby/activemq'

# Class to push to an ActiveMQ queue or topic
class ActiveMQProducer

  # :call-seq:
  #   ActiveMQProducer.new(connection_string: "tcp://localhost:61616", queue: "some-queue")   -> Queue producer
  #   ActiveMQProducer.new(connection_string: "tcp://localhost:61616", topic: "some-topic")   -> Topic producer
  def initialize(hash)
    @connection_string = hash[:connection_string]
    @connection_factory = Java::OrgApacheActivemq::ActiveMQConnectionFactory.new(@connection_string)
    @connection = @connection_factory.create_connection
    @session = @connection.create_session(false, Java::JavaxJms::Session::AUTO_ACKNOWLEDGE)
    if hash[:topic]
      destination = @session.createTopic hash[:topic]
    end
    if hash[:queue]
      destination = @session.createQueue hash[:queue]
    end
    @producer = @session.createProducer destination
    @connection.start
  end

  def send_text_message(string)
    message = @session.create_text_message
    message.set_text string
    @producer.send message
  end

  # :call-seq:
  #    producer.send([1,2,3])
  #    producer.send(Java::byte[3].new)
  def send_bytes_message(array)
    bytes = array
    bytes = array.pack('C*').to_java_bytes if array.is_a?(Array)
    message = @session.create_bytes_message
    message.write_bytes bytes
    @producer.send message
  end

  def close
    @producer.close
    @session.stop
    @session.close
    @connection.stop
    @connection.close
  end

end
