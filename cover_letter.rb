require 'rubygems'
gem "ruby-openai"
require 'json'
require 'openai'

def open_file(file_path)
  File.open(file_path, 'r:UTF-8') do |f|
    return f.read
  end
end

# Save the content to a file with given filepath
def save_file(filepath, content)
  File.open(filepath, 'w:UTF-8') { |f| f.write(content) }
end

# Load information from my_info.json and return it as a hash
def load_info
  info = open_file('my_info.json')
  JSON.parse(info)
end

# Generate completion using OpenAI API
def gpt3_completion(prompt, engine='text-davinci-002', temp=0.7, top_p=1.0, tokens=1000, freq_pen=0.0, pres_pen=0.0, stop=['asdfasdf', 'asdasdf'])
  api_key = open_file("openaiapikey.txt").strip
  client = OpenAI::Client.new(api_key: api_key)

  max_retry = 5
  tryagain = 0
  prompt = prompt.encode(Encoding::ASCII, undef: :replace, invalid: :replace).force_encoding("UTF-8")

  while true
    begin
      response = client.completions(
        engine: engine,
          prompt: prompt,
          temperature: temp,
          max_tokens: tokens,
          top_p: top_p,
          frequency_penalty: freq_pen,
          presence_penalty: pres_pen,
          stop: stop
      )
      text = response['choices'][0]['text'].strip

      filename = "#{Time.now.to_f}_gpt3.txt"
      save_file("gpt3_logs/#{filename}", "#{prompt}\n\n==========\n\n#{text}")
      return text
    rescue => oops
      tryagain += 1
      if tryagain >= max_retry
        return "GPT3 error: #{oops}"
      end
      puts "Error communicating with OpenAI: #{oops}"
      sleep(1)
    end
  end
end

# Main
if __FILE__ == $PROGRAM_NAME
  info = load_info
  text_block = ''
  info.each do |i|
    text_block += "#{i['label']}: #{i['answer']}\n"
  end

  prompt = open_file('prompt_cover_letter.txt').gsub('<<INFO>>', text_block)
  completion = gpt3_completion(prompt)
  puts "\n\nCOVER LETTER: #{completion}"
  save_file("cover_letters/cover_letter_#{Time.now.to_f}.txt", completion)

  prompt = open_file('prompt_professional_objective.txt').gsub('<<INFO>>', text_block)
  completion = gpt3_completion(prompt)
  puts "\n\nPROFESSIONAL OBJECTIVE: #{completion}"
  save_file("objectives/prompt_professional_objective_#{Time.now.to_f}.txt", completion)
end
