class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def format_money(*attributes)
    amount = self.send(*attributes)/100.to_f

    formatted_amount = sprintf("$%.2f", amount)
    if formatted_amount.length > 7
      formatted_amount = formatted_amount.gsub!(/(\d)(?=(\d{3})+(?!\d))/, "\\1,")
    end
    formatted_amount
  end
end

# The regular expression uses a positive lookahead (?=\\d{3}+(?!\d)) to match any digit \d
# that is followed by groups of three digits (\d{3})+ and not followed by another digit (?!\d).
# This allows the regex to match the locations where commas should be inserted to separate thousands.
# The replacement "\\1," places a comma after the matched digit \\1, effectively adding the comma as the thousands separator.