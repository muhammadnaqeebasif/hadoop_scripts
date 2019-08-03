#! /usr/bin/python
from mrjob.job import MRJob
from mrjob.step import MRStep
from collections import defaultdict

class BestRatings(MRJob):

    def mapper(self, _, line):
        (user_id, movie_id, rating,timestamp) = line.split('\t')
        yield movie_id,1

    def combiner(self, movie_id, values):
        yield movie_id, sum(values)

    def reducer(self, movie_id, values):
        yield movie_id, sum(values)

if __name__ == '__main__':
    BestRatings.run()

