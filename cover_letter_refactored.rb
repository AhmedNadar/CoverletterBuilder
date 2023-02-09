#  This is a refactored version of the cover_letter.rb file that uses the functions defined in the gpt3_refactored.rb file. The functions defined in the gpt3_refactored.rb file are imported into the cover_letter_refactored.rb file using the require_relative command. The functions defined in the gpt3_refactored.rb file are then used in the cover_letter_refactored.rb file to generate a cover letter and save it to a file in the cover_letters folder.
require 'rubygems'
gem "ruby-openai"
require 'json'
require 'openai'

# read api key from file and return it as a string
# strip removes whitespace from the beginning and end of the string
def read_api_key
  api_key = open_file("openaiapikey.txt").strip  # add your own api key here
  return api_key
end

# open file and return its content as a string
# def open_file(file_path)
#   File.open(file_path, 'r:UTF-8') do |f|
#     return f.read
#   end
# end
# a shorter version of the open_file function above that uses the File.read method instead of the File.open method to open the file and read its content into a string
# open file and return its content as a string
def open_file(file_path)
  File.read(file_path, encoding: 'UTF-8')
end

# save the content to a file with given filepath
def save_file(filepath, content)
  File.open(filepath, 'w:UTF-8') { |f| f.write(content) }
end

# load information from my_info.json and return it as a hash
def load_info
  info = open_file('my_info.json')
  # JSON.parse converts a string to a hash
  JSON.parse(info)
end

# Generate completion using OpenAI API and save it to a file in gpt3_logs_refactored folder with a timestamp as the filename and the prompt and completion as the content of the file separated by a line of ======== characters
def gpt3_completion(prompt, engine='text-davinci-002', temp=0.7, top_p=1.0, tokens=1000, freq_pen=0.0, pres_pen=0.0, stop=['asdfasdf', 'asdasdf'])
  api_key = read_api_key
  client = OpenAI::Client.new(api_key: api_key)
  # max_retry is the maximum number of times to retry if there is an error communicating with OpenAI
  max_retry = 5
  # tryagain is the number of times we have tried to communicate with OpenAI
  tryagain = 0
  # encode the prompt to ASCII and then back to UTF-8 to remove any non-ASCII characters
  prompt = prompt.encode(Encoding::ASCII, undef: :replace, invalid: :replace).force_encoding("UTF-8")

  # loop forever until we return from the function or raise an error that is not rescued by the rescue block below
  while true
    begin
      # call the OpenAI API to generate a completion and save it to the response variable as a hash
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
      # response['choices'][0]['text'] is the completion generated by the API and strip removes whitespace from the beginning and end of the string and saves it to the text variable as a string
      text = response['choices'][0]['text'].strip

      # save the prompt and completion to a file in gpt3_logs_refactored folder with a timestamp as the filename and the prompt and completion as the content of the file separated by a line of ======== characters
      filename = "gpt3_log_#{Time.now.strftime("%Y_%m_%d-%H.%M.%S")}.txt"
      save_file("gpt3_logs_refactored/#{filename}", "#{prompt}\n\n==========\n\n#{text}")
      return text
    rescue => oops
      # if there is an error communicating with OpenAI, increment tryagain by 1 and if it is greater than or equal to max_retry, return the error message and exit the function and if it is less than max_retry, print the error message and sleep for 1 second and then try again by looping back to the beginning of the function and trying to communicate with OpenAI again
      tryagain += 1
      # raise oops
      if tryagain >= max_retry
        return "GPT3 error: #{oops}"
      end
      puts "Error communicating with OpenAI: #{oops}"
      # sleep for 1 second
      sleep(1)
    end
  end
end

def generate_text_block
  # load information from my_info.json and save it to the info variable as a hash and then loop through the hash and for each item in the hash, add the label and answer to the text_block variable as a string and then return the text_block variable as a string
  info = load_info
  info.each_with_object('') do |i, text_block|
    text_block << "#{i['label']}: #{i['answer']}\n"
  end
end

# def generate_cover_letter
#   # open the prompt_cover_letter.txt file and replace <<INFO>> with the text block generated by the generate_text_block function and save it to the prompt variable as a string and then generate a completion using the gpt3_completion function and save it to the completion variable as a string and then print the completion and save it to a file in cover_letters_refactored folder with a timestamp as the filename and the completion as the content of the file
#   prompt = open_file('prompt_cover_letter.txt').gsub('<<INFO>>', generate_text_block)
#   completion = gpt3_completion(prompt)
#   puts "\n\nCOVER LETTER: #{completion}"
#   save_file("cover_letters_refactored/cover_letter_#{Time.now.strftime("%Y%m%d%H%M%S")}.txt", completion)
# end

# def generate_professional_objective
#   # open the prompt_professional_objective.txt file and replace <<INFO>> with the text block generated by the generate_text_block function and save it to the prompt variable as a string and then generate a completion using the gpt3_completion function and save it to the completion variable as a string and then print the completion and save it to a file in objectives_refactored folder with a timestamp as the filename and the completion as the content of the file
#   prompt = open_file('prompt_professional_objective.txt').gsub('<<INFO>>', generate_text_block)
#   completion = gpt3_completion(prompt)
#   puts "\n\nPROFESSIONAL OBJECTIVE: #{completion}"
#   save_file("objectives_refactored/prompt_professional_#{Time.now.strftime("%Y%m%d%H%M%S")}.txt", completion)
# end

# ====================

def generate_text(prompt_file, output_file_prefix)
  prompt = open_file(prompt_file).gsub('<<INFO>>', generate_text_block)
  completion = gpt3_completion(prompt)
  puts "\n\n#{output_file_prefix.upcase}: #{completion}"
  save_file("#{output_file_prefix}_refactored/#{output_file_prefix}_#{Time.now.strftime("%Y_%m_%d-%H.%M.%S")}.txt", completion)
end

def generate_cover_letter
  generate_text('prompt_cover_letter.txt', 'cover_letters')
end

def generate_professional_objective
  generate_text('prompt_professional_objective.txt', 'objectives')
end
# The code defines two methods generate_cover_letter and generate_professional_objective and one helper method generate_text which is used by both the methods.

# The method generate_text accepts two arguments prompt_file and output_file_prefix.

# The method open_file is used to open the file located at the path prompt_file and replace all instances of the string "<<INFO>>" with the result of calling generate_text_block.
# The resulting string is then passed as an argument to gpt3_completion to generate a completion and store it in the completion variable.
# The method outputs the completion and then calls save_file to save the completion to a file located at the path "#{output_file_prefix}refactored/#{output_file_prefix}#{Time.now.strftime("%Y_%m_%d-%H.%M.%S")}.txt".
# The generate_cover_letter method simply calls the generate_text method with the arguments 'prompt_cover_letter.txt' and 'cover_letters'.

# The generate_professional_objective method is similar to generate_cover_letter, but instead of calling generate_text with the arguments 'prompt_cover_letter.txt' and 'cover_letters', it calls generate_text with the arguments 'prompt_professional_objective.txt' and 'objectives'.

generate_cover_letter
generate_professional_objective
