# -*- coding: utf-8 -*-

##########################################################################################
# @author Rodrigo Botafogo
#
# Copyright © 2015 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
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

require 'rbconfig'
require 'java'

#=========================================================================================
# In principle should not be in this file.  The right way of doing this is by executing
# bundler exec, but I don't know how to do this from inside emacs.  So, should comment
# the next line before publishing the GEM.  If not commented, this should be harmless
# anyway.
#=========================================================================================

begin
  require 'bundler/setup'
rescue LoadError
end

#---------------------------------------------------------------------------------------
# Set the project directories
#---------------------------------------------------------------------------------------

class Blis

  #-------------------------------------------------------------------------------------
  # Instance variables with information about directories and files used
  #-------------------------------------------------------------------------------------
  
  @home_dir = File.expand_path File.dirname(__FILE__)

  class << self
    attr_reader :home_dir
  end

  @project_dir = Blis.home_dir + "/.."
  @doc_dir = Blis.home_dir + "/doc"
  @lib_dir = Blis.home_dir + "/lib"
  @src_dir = Blis.home_dir + "/src"
  @target_dir = Blis.home_dir + "/target"
  @test_dir = Blis.home_dir + "/test"
  @vendor_dir = Blis.home_dir + "/vendor"
  @js_dir = Blis.home_dir + "/node_modules"

  class << self
    attr_reader :project_dir
    attr_reader :doc_dir
    attr_reader :lib_dir
    attr_reader :src_dir
    attr_reader :target_dir
    attr_reader :test_dir
    attr_reader :vendor_dir
  end

  @build_dir = Blis.src_dir + "/build"

  class << self
    attr_reader :build_dir
  end

  @classes_dir = Blis.build_dir + "/classes"

  class << self
    attr_reader :classes_dir
  end

  #-------------------------------------------------------------------------------------
  # Environment information
  #-------------------------------------------------------------------------------------

  @platform = 
    case RUBY_PLATFORM
    when /mswin/ then 'windows'
    when /mingw/ then 'windows'
    when /bccwin/ then 'windows'
    when /cygwin/ then 'windows-cygwin'
    when /java/
      require 'java' #:nodoc:
      if java.lang.System.getProperty("os.name") =~ /[Ww]indows/
        'windows-java'
      else
        'default-java'
      end
    else
      'default'
    end
  
  @host_os = RbConfig::CONFIG['host_os']
  @host_cpu = RbConfig::CONFIG['host_cpu']

  #-------------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------------

  def self.windows?
    !(@host_os =~ /mswin|mingw/).nil?
  end  

  #-------------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------------

  def self.linux32?
    (!(@host_os =~ /linux/).nil? && !(@host_cpu =~ /x86_32/).nil?)
  end

  #-------------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------------

  def self.linux64?
    (!(@host_os =~ /linux/).nil? && !(@host_cpu =~ /x86_64/).nil?)
  end

  #-------------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------------

  def self.mac?
    !(@host_os =~ /mac|darwin/).nil?
  end
  
  #-------------------------------------------------------------------------------------
  #
  #-------------------------------------------------------------------------------------

end

#----------------------------------------------------------------------------------------
# If we need to test for coverage
#----------------------------------------------------------------------------------------

if $COVERAGE == 'true'
  
  require 'simplecov'
  
  SimpleCov.start do
    @filters = []
    add_group "Blis"
  end
  
end

