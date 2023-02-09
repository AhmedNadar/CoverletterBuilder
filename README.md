# CoverletterBuilder
  Cover letter and professional objectives by Ruby and GPT3

## Introduction
- This is a simple Ruby script that generates a cover letter and professional objectives by using [GPT-3 API](https://beta.openai.com/docs/api-reference/introduction) from [OpenAI](https://openai.com/).
- This is a work in progress. I'm still working on it. I'll update this README as I go.
- I'm open to suggestions and improvements. Please feel free to open an issue or a PR.

## Gems & APIs
  I'm using the follwing:
  - [OpenAI](https://openai.com/) to generate a cover letter and a professional objectives.
  - [GPT-3](https://openai.com/blog/gpt-3-apps/) APIs.
  - [OpenAI Ruby gem](https://github.com/alexrudall/ruby-openai) to interact with OpenAI API.
  - [JSON](https://www.json.org/json-en.html) to store my personal information and to store my cover letter and professional objectives.
  - [JSON gem](https://rubygems.org/gems/json/versions/2.3.0) to parse JSON files.

## Setup
- Make sure you have Ruby installed in your machine. [GoRails](https://gorails.com/setup/macos/13-ventura) have a great guide on installing Ruby, Rails and it's ecosystem. Select your OS and it's version. Follow instructions to install Rails ecosytem -if you want, while it's not required for this repo- or head to **Installing Ruby** section
- Grap your [OpenAI api key](https://platform.openai.com/account/api-keys) from OpenAI and replace current placeholder text inside `openaiapikey_yours.txt` with a new/working api.
- Update `my_info.json` file with your personal information.
- Run ruby `coverletter.rb` for my first itteration or `ruby coverletter_refactor.rb` for refactored file which includes usefull comments to generate your cover letter and professional objectives.
- You all set. Enjoy!

