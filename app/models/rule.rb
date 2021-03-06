class Rule < ApplicationRecord
  belongs_to :group
  has_many :tokens
  validates :name, presence: true, length: { maximum: 50 }

  def check_source(person)
    sources = tokens.select {|a| a.type == "source" }

    return false if sources.empty?

    sources.each do |token|
      if token.check(person)
        return true unless source_match_all
      elsif source_match_all
        return false
      end
    end
    
    source_match_all
  end

  def check_rule(person)
    any = tokens.select {|a| a.type == "whitelist" }.empty?
    tokens.select {|a| a.type == "whitelist" }.each do |token|
      if token.check(person)
        any = true
      elsif whitelist_match_all
        return false
      end
    end

    return false if !whitelist_match_all && !any

    tokens.select {|a| a.type == "blacklist" }.each do |token|
      return false if token.check(person)
    end

    true
  end
end
