class Update
  attr_reader :pages
  # @param pages [Array[Integer]]
  def initialize(pages)
    @pages = pages
    @last_index = pages.size - 1
  end

  def pages_after_index(index)
    return [] if index >= @last_index
    @pages[(index + 1)..@last_index]
  end

  # @param rule_book [RuleBook]
  # @return [Array[Integer]]
  def fixup_pages(rule_book)
    new_pages = []

    @pages.each do |page|
      page_used = false

      new_pages.each_with_index do |new_page, index|
        next if page_used

        # if the page needs to go infront, put it in front
        if rule_book.pages_that_must_come_before(new_page).include?(page)
          new_pages.insert(index, page)
          page_used = true
        end
      end

      # if none of the current pages needed this in front, put it in back
      new_pages << page unless page_used
    end

    @pages = new_pages
  end

  # @return [Integer]
  def middle_page
    @pages[(@pages.size / 2)]
  end
end

class RuleBook
  attr_reader :pages_that_must_come_before_hash
  # @param rules [Array[Integer,Integer]] before, after
  def initialize(rule_pairs)
    # keys are the pages, values are the array of pages that must come before
    @pages_that_must_come_before_hash = {}
    rule_pairs.each do |pair|
      @pages_that_must_come_before_hash[pair[1]] ||= []
      @pages_that_must_come_before_hash[pair[1]] << pair[0]
    end
  end

  # @param update [Update]
  # @return [Boolean]
  def follows_rules?(update)
    # all pages follow the rule if there are no pages after that must come before
    update.pages.each_with_index.all? do |page, index|
      pages_that_must_come_before = pages_that_must_come_before(page)
      next true if pages_that_must_come_before.empty?

      update.pages_after_index(index).all? do |page_after|
        !pages_that_must_come_before.include?(page_after)
      end
    end
  end

  # @param page [Integer]
  # @return [Array[Integer]]
  def pages_that_must_come_before(page)
    @pages_that_must_come_before_hash.fetch(page, [])
  end
end

on_rules = true
rules = []
updates = []

file = '2024/day_5_printing/input.txt'
f = File.open(file, "r")
f.each_line do |line|
  if on_rules
    line = line.strip.split('|').map(&:to_i)
    if line.empty?
      on_rules = false
      next
    end

    rules << line
  else
    updates << Update.new(line.strip.split(',').map(&:to_i))
  end
end

rule_book = RuleBook.new(rules)

middle_pages = []

updates.each do |update|
  if !rule_book.follows_rules?(update)
    update.fixup_pages(rule_book)
    middle_pages << update.middle_page
  end
end

pp middle_pages.sum