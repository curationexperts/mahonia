# frozen_string_literal: true

##
# Formats messages from the import process for nicer output
class MessageStream
  def <<(msg)
    STDOUT << format_message(msg)
  end

  def format_message(msg)
    msg.to_s + "\n"
  end
end
