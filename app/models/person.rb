class Person < ApplicationRecord
  belongs_to :group
  validates :name, presence: true, length: { maximum: 50 }
  validates :family, length: { maximum: 50 }

  def apply_rules(people, rules)
  	rules.each { |rule|
  		if people.reject { |person| rule.check_source(self) && !rule.check_rule(person) }.length >= 1
  			people.reject! { |person| rule.check_source(self) && !rule.check_rule(person) }
  		end
  	}
  end
end
