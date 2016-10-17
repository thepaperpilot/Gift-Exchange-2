class Token < ApplicationRecord
  belongs_to :rule
  self.inheritance_column = :_type_disabled

  def check(person)
    if token.nil? || token == ""
      return false
    end

    if regex
      if self.case
        test = /#{Regexp.quote(token.upcase)}/
        if names and person.name != ""
          if groups and person.family != ""
            return true if (test.match person.name.upcase) != invert || (test.match person.family.upcase) != invert
          else
            return true if (test.match person.name.upcase) != invert
          end
        elsif groups and person.family != ""
          return true if (test.match person.family.upcase) != invert
        end
      elsif
        test = /#{Regexp.quote(token)}/
        if names and person.name != ""
          if groups and person.family != ""
            return true if (test.match person.name) != invert || (test.match person.family) != invert
          else
            return true if (test.match person.name) != invert
          end
        elsif groups and person.family != ""
          return true if (test.match person.family) != invert
        end
      end
    else
      if self.case
        if names and person.name != ""
          if groups and person.family != ""
            return true if (person.family.upcase.include? token.upcase) != invert || (person.name.upcase.include? token.upcase) != invert
          else
            return true if (person.name.upcase.include? token.upcase) != invert
          end
        elsif groups and person.family != ""
          return true if (person.family.upcase.include? token.upcase) != invert
        end
      else
        if names and person.name != ""
          if groups and person.family != ""
            return true if (person.family.include? token) != invert || (person.name.include? token) != invert
          else
            return true if (person.name.include? token) != invert
          end
        elsif groups and person.family != ""
          return true if (person.family.include? token) != invert
        end
      end
    end

    false
  end
end
