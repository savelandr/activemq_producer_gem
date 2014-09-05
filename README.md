#ActiveMQ Producer
##Description
Helper to send messages to an ActiveMQ
##Example
```
require 'activemq_producer'

producer=ActiveMQProducer.new(connection_string: "tcp://localhost:61616", queue: "some-queue")
producer.send_text_message "I love Apache"
producer.send_bytes_message [1,2,3]
producer.close
```
