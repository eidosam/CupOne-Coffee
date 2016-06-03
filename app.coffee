# class for running reguests parallel
DataFetch = require('./data-fetch')
# class for analyzing the text to find the top N words
TextAnalyzer = require('./text-analyse')
# list of URLs of files
urls = [
  'http://textfiles.com/humor/calculus.txt'
  'http://textfiles.com/humor/college.txt'
  'http://textfiles.com/humor/drinker.txt'
  'http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-test.txt'
  'http://www.ssec.wisc.edu/~billh/README.text'
]
# an instance of data-fetcher class
dataFetch = new DataFetch(urls)
# set the configurations of retry-attempts
# process the fetched data

processData = (data) ->
  if !data
    console.log 'There is no text to handle, Sorry!'
    return
  # an instance of text-analyzer class
  ta = new TextAnalyzer(data)
  # set configurations to the data-fetcher, 
  # how to deal with thenon - words and common words
  ta.setConfigurations
    topWordsCount: 10
    excludeCommonWords: true
    excludeNumbers: true
    fairStrategy: true
  # hold the results of top-10-words
  result_ = ta.getTopNWords()
  # showing the data
  # header
  console.log 'Here you find the most used word:'
  console.log '________________________________'
  console.log ' Ocuurences\u0009| Word'
  console.log '----------------+---------------'
  # data show
  for i of result_
    console.log ' ' + result_[i].count + '\u0009\u0009| ' + result_[i].word
  # footer
  console.log '________________|_______________'
  return

dataFetch.setConfigurations {
    maxAttempts: 10
    retryDelay: 100
  }
# start request data from URLs
# and pass the results to the data-processing function
dataFetch.startFetch processData
