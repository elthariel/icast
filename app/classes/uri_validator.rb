class UriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      unless URI.parse(value).kind_of?(URI::HTTP)
        record.errors.add attribute, (options[:message] || "is not a valid HTTP URI")
      end
    rescue URI::InvalidURIError
      record.errors.add attribute, (options[:message] || "is not a valid HTTP URI")
    end
  end
end
