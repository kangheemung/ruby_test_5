#あなたは7日間の連休をもらいましたが、降水確率が 30% 以下ならば外に出掛ける事に決めました。
#7日間の降水確率(%)が改行区切りで入力されるので、出掛ける日数の合計を出力してください。

#入力される値
#入力は以下のフォーマットで与えられます。

#t_1
#t_2
#t_3
#t_4
#t_5
#t_6
#t_7
t_1 = gets.chomp.to_i
t_2 = gets.chomp.to_i
t_3 = gets.chomp.to_i
t_4 = gets.chomp.to_i
t_5 = gets.chomp.to_i
t_6 = gets.chomp.to_i
t_7 = gets.chomp.to_i

input_values = [t_1, t_2, t_3, t_4, t_5, t_6, t_7]

if input_values.all? { |value| (0..100).cover?(value) }
  outings = input_values.count { |value| value <= 30 }
  puts outings
else
  puts "no"
end
