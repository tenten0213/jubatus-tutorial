#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

HOST = "127.0.0.1"
PORT = 9199
NAME = "recommender_baseball";

require 'json'
require 'jubatus/recommender/client'

File.open("dat/baseball.csv") {|f|
  recommender = Jubatus::Recommender::Client::Recommender.new(HOST, PORT, NAME)
  columns = ["打率", "試合数", "打席", "打数", "安打", "本塁打", "打点", "盗塁", "四球", "死球", "三振", "犠打", "併殺打", "長打率", "出塁率", "OPS", "RC27", "XR27"]
  f.each {|line|
    pname, team = line.split(",")
    parameters = { "チーム" => team }
    columns.zip(line.split(",")[2..-1])
      .each{|key, value| parameters[key] = value.to_f }
    datum = Jubatus::Common::Datum.new(parameters)
    recommender.update_row(pname, datum)
    puts "set #{pname}: #{columns.slice(0..4).map{ |key| parameters[key]}}..."
  }
}
