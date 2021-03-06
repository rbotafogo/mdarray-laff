# -*- coding: utf-8 -*-

##########################################################################################
# Copyright © 2017 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
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
require 'mdarray-blis'


class MDArrayTest < Test::Unit::TestCase

  context "Blis" do

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    setup do 

      # row vector
      @r_vec = MDArray.double([1, 5], [2, -1, 4, 2, 1])
      # column vector
      @c_vec = MDArray.double([5, 1], [1, -2, 2, 3, -1])
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do axpy between two vectors using Blis library (no error checking)" do

      v1 = MDArray.double([5, 1], [2, -1, 4, 2, 1])
      v2 = MDArray.double([5, 1], [1, -2, 2, 3, -1])

      axpy = MDArray.double([5, 1], [-1.0, -1.0, -2.0, 1.0, -2.0])
      
      # now destroy the first vector with the result
      Blis.axpyv(-1, v1, v2)
      assert_equal(true, v2.identical(axpy))
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "copy a vector into another vector" do

      v1 = MDArray.double([5, 1])
      Blis.copyv(v1, @c_vec)
      assert_equal(true, v1.identical(@c_vec))
      
    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do dot product between two vectors using Blis library (no error checking)" do

      # return the dot product as a scalar from dotv method
      assert_equal(17, Blis.dotv(@r_vec, @c_vec))
      # does not do any error checking, so a colum vector dot a row vector works fine.
      assert_equal(17, Blis.dotv(@c_vec, @r_vec))

      # fill a 1 x 1 matrix (scalar) with the result of the dot procuct.  This operation
      # might be necessary when slicing/dicing a matrix that needs to be updated with
      # the dot product
      dot = MDArray.double([1, 1])
      Blis.dotv(@r_vec, @c_vec, dot)
      assert_equal(17, dot)

    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do extended dot product between two vectors" do

      # dotxv returns a scalar with the extended dot product
      assert_equal(17, Blis.dotxv(1, @r_vec, @c_vec, 1))

      # store thet dot product in a matrix of size [1, 1] (scalar)
      dot = MDArray.double([1, 1], [0])
      Blis.dotxv(1, @r_vec, @c_vec, 1, dot)
      assert_equal(true, dot.identical(MDArray.double([1, 1], [17])));

      dot[0, 0] = 5
      Blis.dotxv(1, @r_vec, @c_vec, 1, dot)
      assert_equal(true, dot.identical(MDArray.double([1, 1], [22])));
      
    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "do dot product between two vectors using ruby interface" do

      assert_equal(17, @r_vec.dotv(@c_vec))

      # Will raise an error, since dotv expects a row vector as first operand
      assert_raise (RuntimeError) { @c_vec.dotv(@r_vec) }
      
    end

    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "invert a vector using Blis library" do

      Blis.invertv(@r_vec)
      assert_equal(true,
                   @r_vec.identical(MDArray.double([1, 5],
                                                   [1/2.0, -1.0, 1.0/4, 1.0/2, 1.0])))
      
    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "scale a vector destructively" do

      Blis.scalv(5, @r_vec)
      res = MDArray.double([1, 5], [5 * 2, 5 * -1, 5 * 4, 5 * 2, 5 * 1])
      assert_equal(true, res.identical(@r_vec))

    end
    
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

    should "scale a vector constructing a new one" do

      scal = MDArray.double([1, 5])
      Blis.scal2v(5, @r_vec, scal)
      res = MDArray.double([1, 5], [5 * 2, 5 * -1, 5 * 4, 5 * 2, 5 * 1])
      assert_equal(true, res.identical(scal))

    end

  end

end
