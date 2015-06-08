
def initialize_deck
  ranks = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  suits = %w(Spades Hearts Diamonds Clubs)
  suits.product(ranks).shuffle!
end

def ask name
  puts "What is your name?"
  name << gets.chomp
  puts "Ok #{name}, lets start the game!"
  puts "********************************"
end

def total(cards)
  #total_score.clear
  score = 0
  valid_card = cards.flatten.select {|card| card.length < 3}
  valid_card.each do |card|
    case 
    when card.to_i != 0 then score += card.to_i
    when card.to_i == 0 && card != "A" then score += 10 
    when card == "A" && score <= 10 then score += 11
    when card == "A" && score > 10 then score += 1
    end
  end
  #score = score.to_s
  score
  #total_score << score
end

def dealer_score_at_first_card(dealer_cards, dealer_first_card)
  dealer_first_card << "11" if dealer_cards.first.last == "A"
  dealer_first_card << "10" if dealer_cards.first.last.to_i == 0 && dealer_cards.first.last != "A"
  dealer_first_card << dealer_cards.first.last if dealer_cards.first.last.to_i != 0 
end

def another_hit(have_a_winner, player_cards, player_name, total_score_player, dealer_cards, total_score_dealer, deck)
  puts "Dealer has #{dealer_cards.last} and a total of #{total_score_dealer}"
  player_cards << deck.pop
  total(player_cards, total_score_player)
  puts "#{player_name} Your new card is #{player_cards.last} and your total is #{total_score_player}."
  if total_score_player.to_i == 21
    puts "#{player_name} wins with 21. BLACKJACK!"
    have_a_winner.clear << "true"
  elsif total_score_player.to_i > 21
    puts "#{player_name} has busted with #{total_score_player}. Dealer win with #{total_score_dealer}"
    have_a_winner.clear << "true"
  elsif total_score_player.to_i == 21 && total_score_dealer == 21
    puts "It is a tie with #{total_score_player}."
    have_a_winner.clear << "true"
  else
    have_a_winner.clear << "false"
  end
end

def dealer_time(deck, dealer_cards, player_cards, player_name, total_score_dealer, total_score_player, have_a_winner)
  puts "Dealer has as well #{dealer_cards.last} and a total of #{total_score_dealer}"
  if total_score_dealer.to_i == 21
    puts "Dealer wins with 21. BLACKJACK!"
    have_a_winner.clear << "true"
  elsif total_score_dealer.to_i > 21
    puts "Dealer has busted with #{total_score_dealer}. You win with #{total_score_player}"
    have_a_winner.clear << "true"
  elsif total_score_player.to_i > 21
    puts "You have busted with #{total_score_player}. Dealer win with #{total_score_dealer}"
    have_a_winner.clear << "true"
  elsif total_score_dealer.to_i == total_score_player.to_i && total_score_dealer.to_i != 21
    puts "This is a tie! you both have #{total_score_dealer}"
    have_a_winner.clear << "true"
  elsif total_score_dealer.to_i >= 17 && (total_score_dealer.to_i > total_score_player.to_i && total_score_dealer.to_i < 21)
    puts "Dealer has #{total_score_dealer} and win against your #{total_score_player}!"
    have_a_winner.clear << "true"
  elsif total_score_dealer.to_i >= 17 && (total_score_dealer.to_i > total_score_player.to_i && total_score_dealer.to_i > 21)
    puts "Dealer has #{total_score_dealer} and bust! you win with #{total_score_player}!"
    have_a_winner.clear << "true"
  elsif total_score_dealer.to_i >= 17 && (total_score_dealer.to_i < total_score_player.to_i && total_score_dealer.to_i < 21)
    puts "Dealer Hit"
    dealer_cards << deck.pop
    total_score_dealer
    have_a_winner.clear << "false"
  else
    puts "Dealer Hit"
    dealer_cards << deck.pop
    total_score_dealer
    have_a_winner.clear << "false"
  end
end

deck = initialize_deck

player_name = ""

play_again = "y"


puts "WELCOME TO BLACKJACK!"

ask player_name

while play_again == "y" 
  deck

  player_cards = []

  dealer_cards = []

  total_score_player = total(player_cards)

  total_score_dealer = total(dealer_cards)

  dealer_first_card = ""

  have_a_winner = ""

  puts "WELCOME TO BLACKJACK #{player_name.upcase}!"

  player_cards << deck.pop
  dealer_cards << deck.pop
  player_cards << deck.pop
  dealer_cards << deck.pop

  total_score_player
  total_score_dealer
  dealer_score_at_first_card(dealer_cards, dealer_first_card)

  puts "#{player_name}, you have #{player_cards[0]} and #{player_cards[1]}. Total of #{total_score_player}"
  puts "Dealer has #{dealer_cards[0]} and a hidden card. Total of #{dealer_first_card}"

  while have_a_winner != "true"
    puts "If you want to hit again press 1 or 2 to stay."
    hit_or_stay = gets.chomp
    if hit_or_stay == "2" #player stay
      if total_score_dealer.to_i == 21
        puts "Dealer wins with 21. BLACKJACK!"
        have_a_winner.clear << "true"
      end
      while have_a_winner != "true"
        dealer_time(deck, dealer_cards, player_cards, player_name, total_score_dealer, total_score_player, have_a_winner)
      end
      break
    elsif hit_or_stay == "1" #player hit
      another_hit(have_a_winner, player_cards, player_name, total_score_player, dealer_cards, total_score_dealer, deck)
    else
      puts "Wrong input..."
      next
    end
  end 
  puts ""
  puts "Do you want to play again? (y/n)"
  play_again = gets.chomp.downcase
  puts ""
  if play_again != "y"
    puts "OK, See you soon.."
  end  
end  



