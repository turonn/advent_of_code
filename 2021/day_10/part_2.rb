file='2021/day_10/input.txt'
scores = []
closing_characters = ['}', '>', ']', ')']
opening_characters = ['{', '<', '[', '(']

f = File.open(file, "r")
f.each_line do |line|
  skip = false
  bank = []
  arr = line.strip.split('')
  arr.each do |char|
    if opening_characters.include?(char)
      bank << char
      next
    end
    
    if bank.empty? && closing_characters.include?(char)
      pp "blank"
    end

    case char
    when ')' 
      if bank[-1] == '(' 
        bank.pop 
      else
        skip = true
        break
      end
    when ']' 
      if bank[-1] == '[' 
        bank.pop 
      else
        skip = true
        break
      end
    when '}' 
      if bank[-1] == '{' 
        bank.pop 
      else
        skip = true
        break
      end
    when '>' 
      if bank[-1] == '<' 
        bank.pop 
      else
        skip = true
        break
      end
    else 
      pp "error on line #{arr}"
    end
  end

  unless skip
    score = 0
    bank.reverse.each do |char|
      case char
      when '(' 
        score = (score * 5) + 1
      when '[' 
        score = (score * 5) + 2
      when '{' 
        score = (score * 5) + 3
      when '<' 
        score = (score * 5) + 4
      else 
        pp "error on line #{arr}"
      end
    end

    scores << score
  end
end

pp scores.sort[scores.size/2]