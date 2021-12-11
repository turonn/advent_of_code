file='2021/day_10/input.txt'
score = 0
closing_characters = ['}', '>', ']', ')']
opening_characters = ['{', '<', '[', '(']

f = File.open(file, "r")
f.each_line do |line|
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
       bank[-1] == '(' ? bank.pop : (break score += 3)
    when ']' 
       bank[-1] == '[' ? bank.pop : (break score += 57)
    when '}' 
       bank[-1] == '{' ? bank.pop : (break score += 1197)
    when '>' 
       bank[-1] == '<' ? bank.pop : (break score += 25137)
        
    else 
      pp "error on line #{arr}"
    end
  end
end

pp score