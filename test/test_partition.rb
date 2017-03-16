# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2016 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation, without fee and without a signed 
# licensing agreement, is hereby granted, provided that the above copyright notice, this 
# paragraph and the following two paragraphs appear in all copies, modifications, and 
# distributions.
#
# IN NO EVENT SHALL RODRIGO BOTAFOGO BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF 
# THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF RODRIGO BOTAFOGO HAS BEEN ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# RODRIGO BOTAFOGO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
# SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". 
# RODRIGO BOTAFOGO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, 
# OR MODIFICATIONS.
##########################################################################################

require "test/unit"
require 'shoulda'

require '../config' if @platform == nil
require 'mdarray-laff'


class MDArrayLaffTest < Test::Unit::TestCase

  context "Laff" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      # a vector is an MDArray with one of it´s dimension equal to 1
      # this is a row vector with 4 rows and 1 column
      @r_vec = MDArray.double([1, 4], [1, 2, 3, 4])
      @r_vec2 = MDArray.double([1, 4], [1, 2, 3, 5])
      @c_vec = MDArray.double([4, 1], [1, 2, 3, 4])
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by rows top to bottom" do

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_row_tb
      at, ab = Laff.part_by_row_tb(@c_vec, part_size: 1)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(at))
      assert_equal(true, MDArray.double([3, 1], [2, 3, 4]).identical(ab))

      # filter the results returning only the right vector
      ret = Laff.part_by_row_tb(@c_vec, part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([2, 1], [3, 4]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = Laff.part_by_row_tb(@c_vec, part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([2, 1], [1, 2]).identical(ret[0]))

      # filter the results returning only the top vector
      ret = Laff.part_by_row_tb(@c_vec, part_size: 3, filter: 0b10)
      assert_equal(true, MDArray.double([3, 1], [1, 2, 3]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by rows bottom to top" do

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_row_bt
      at, ab = Laff.part_by_row_bt(@c_vec, part_size: 1)
      assert_equal(true, MDArray.double([3, 1], [1, 2, 3]).identical(at))
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ab))

      # filter the results returning only the bottom vector
      ret = Laff.part_by_row_bt(@c_vec, part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([2, 1], [3, 4]).identical(ret[0]))

      # filter the results returning only the top vector
      ret = Laff.part_by_row_bt(@c_vec, part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([2, 1], [1, 2]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = Laff.part_by_row_bt(@c_vec, part_size: 3, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by columns left to right" do

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_column_lr
      al, ar = Laff.part_by_column_lr(@r_vec, part_size: 1)
      assert_equal(true, MDArray.double([1, 1],[1]).identical(al))
      assert_equal(true, MDArray.double([1, 3], [2, 3, 4]).identical(ar))

      # filter the results returning only the right vector
      ret = Laff.part_by_column_lr(@r_vec, part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([1, 2], [3, 4]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = Laff.part_by_column_lr(@r_vec, part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([1, 2], [1, 2]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = Laff.part_by_column_lr(@r_vec, part_size: 3, filter: 0b10)
      assert_equal(true, MDArray.double([1, 3], [1, 2, 3]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition a vector by columns right to left" do

      # partitions the array with the left part with 2 columns and the right part
      # with the rest of the columns
      # al, ar = Laff.part_by_column_rl
      al, ar = Laff.part_by_column_rl(@r_vec, part_size: 1)
      assert_equal(true, MDArray.double([1, 3], [1, 2, 3]).identical(al))
      assert_equal(true, MDArray.double([1, 1], [4]).identical(ar))

      # filter the results returning only the right vector
      ret = Laff.part_by_column_rl(@r_vec, part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([1, 2], [3, 4]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = Laff.part_by_column_rl(@r_vec, part_size: 2, filter: 0b10)
      assert_equal(true, MDArray.double([1, 2], [1, 2]).identical(ret[0]))

      # filter the results returning only the left vector
      ret = Laff.part_by_column_rl(@r_vec, part_size: 3, filter: 0b10)
      assert_equal(true, MDArray.double([1, 1], [1]).identical(ret[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition an array by columns left to right" do
    
      array = MDArray.double([2, 3], [1, 2, 3, 4, 5, 6])

      al, ar = Laff.part_by_column_lr(array, part_size: 1)
      assert_equal(true, MDArray.double([2, 1], [1, 4]).identical(al))
      assert_equal(true, MDArray.double([2, 2], [2, 3, 5, 6]).identical(ar))

      # get only the left side.  The returned value is an array of size 1
      al = Laff.part_by_column_lr(array, part_size: 1, filter: 0b10)
      assert_equal(true, MDArray.double([2, 1], [1, 4]).identical(al[0]))

      # get only the right side.  The returned value is an array of size 1
      ar = Laff.part_by_column_lr(array, part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([2, 1], [3, 6]).identical(ar[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition an array by columns right to left" do
    
      array = MDArray.double([2, 3], [1, 2, 3, 4, 5, 6])

      al, ar = Laff.part_by_column_rl(array, part_size: 1)
      assert_equal(true, MDArray.double([2, 2], [1, 2, 4, 5]).identical(al))
      assert_equal(true, MDArray.double([2, 1], [3, 6]).identical(ar))

      # get only the left side.  The returned value is an array of size 1
      al = Laff.part_by_column_rl(array, part_size: 1, filter: 0b10)
      assert_equal(true, MDArray.double([2, 2], [1, 2, 4, 5]).identical(al[0]))

      # get only the right side.  The returned value is an array of size 1
      ar = Laff.part_by_column_rl(array, part_size: 2, filter: 0b01)
      assert_equal(true, MDArray.double([2, 2], [2, 3, 5, 6]).identical(ar[0]))

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "partition two vectors synchronized" do
=begin
      Laff.part_synchronized(@r_vec, Laff.method(:part_by_column_lr),
                     @c_vec, Laff.method(:part_by_row_tb),
                     vec_size: @r_vec.shape[1]) do |vec1_l, vec1_r, vec2_t, vec2_b|
        vec1_l.pp
        vec1_r.pp
        vec2_t.pp
        vec2_b.pp
      end

=end      
      Laff.part_synchronized(@r_vec, Laff.method(:part_by_column_lr),
                             @c_vec, Laff.method(:part_by_row_tb),
                             vec_size: @r_vec.shape[1], filter1: 0b01,
                             filter2: 0b01) do |vec1_r, vec2_b|
        vec1_r.pp
        vec2_b.pp
      end
      
    end
    
  end
  
end
