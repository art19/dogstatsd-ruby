# frozen_string_literal: true

require 'concurrent'
require 'monitor'

module Datadog
  class Statsd
    class Batch
      include MonitorMixin

      def initialize(connection, max_buffer_bytes)
        super()

        @connection = connection
        @max_buffer_bytes = max_buffer_bytes
        @depth = 0
        reset
      end

      def open
        synchronize { @depth += 1 }
        yield
      ensure
        synchronize { @depth -= 1 }
        flush if !open?
      end

      def open?
        @depth > 0
      end

      def add(message)
        synchronize do
          message_bytes = message.bytesize

          unless @buffer_bytes == 0
            if @buffer_bytes + 1 + message_bytes >= @max_buffer_bytes
              flush
            else
              @buffer << "\n"
              @buffer_bytes += 1
            end
          end

          @buffer << message
          @buffer_bytes += message_bytes
        end
      end

      def flush
        return if @buffer_bytes == 0
        @connection.write(@buffer)
        reset
      end

      private

      def reset
        @buffer = String.new
        @buffer_bytes = 0
      end
    end
  end
end
