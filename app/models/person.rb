class Person < ApplicationRecord
  belongs_to :group
  validates :name, presence: true, length: { maximum: 50 }

  def apply_rules(people, rules)
    puts "before: #{people.inspect()}"
    puts people.size
    people.delete_if { |person| rules.any? { |rule| rule.check_source(self) && !rule.check_rule(person) } }
    puts "after: #{people.inspect()}"
  end
end
