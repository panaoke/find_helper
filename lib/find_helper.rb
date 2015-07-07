require 'find_helper'
require 'find_helper/version'
require 'find_helper/scope'
require 'find_helper/format_finder_value'
require 'find_helper/active_record_finder'
require 'find_helper/mongoid_finder'
require 'find_helper/engine'

=begin
  用来扩展model的查询能力
     1. 通过参数来实现级联调用named_scope的效果
     2. 提供包含多种比较条件的查询
     3. 自动将特殊字段类型的查询值转换, 包含日期, 时间, 数组, 数组, 布尔

  Example:

  class Product < ActiveRecord::Base

    include FindHelper    # 引入hash级联查询能力

    定义一个字段name的like查询scope
    named_scope :product_name, { |name| :conditions => ['name like ?', "%{name}%"])

    named_scope :price_gte, {|price| :conditions => ['price_gte >= ?', price]}

  end

  常规查询方法 VS  hash级联查询查询方法(by_scopes)
  查询 name like 'prom', price 大于 100的

  Product.name('prom').price_gte(100)
                       |
                       v
  Product.by_scopes({:name => 'prom', :price_gte => 100})

  同时还支持

  1. 一般查询扩展
      Product.by_scopes({:product_name => 'prom', :price_gte => 100, :domain_id => 5})
                                 |
                                 v
      Product.product_name('prom').price_gte(100).find(:all, :conditions => {'products.domain_id = ?', 5})

  2. 默认去除空值查询条件
      Product.by_scopes({:product_name => '', :price_gte => 100, :domain_id => 5})
                                 |
                                 v
      Product.price_gte(100).find(:all, :conditions => {'products.domain_id = ?', 5})

      不去除空值查询条件
      Product.by_scopes({:name => '', :price_gte => 100, :domain_id => 5}, false)
                                 |
                                 v
      Product.product_name('').price_gte(100).find(:all, :conditions => {'products.domain_id = ?', 5})

  3. $like(模糊)查询
      Product.by_scopes({:$like_name => 'prom'})
                            |
                            v
      Product.find(:all, :conditions => ['products.name like ?', "%prom%"])

  4. $gt(大于)查询
      Product.by_scopes({:$gt_price => '100'})
                            |
                            v
      Product.find(:all, :conditions => ['products.price > ?', 100])

  5. $gte(大于等于)查询
      Product.by_scopes({:$gte_price => '100'})
                            |
                            v
      Product.find(:all, :conditions => ['products.price >= ?', 100])

  6. $le(小于)查询
      Product.by_scopes({:$le_price => '100'})
                            |
                            v
      Product.find(:all, :conditions => ['products.price < ?', 100])

  7. $lte(等于小于)查询
      Product.by_scopes({:$le_price => '100'})
                            |
                            v
      Product.find(:all, :conditions => ['products.price <= ?', 100])

  8. $ne(不等于)查询
      Product.by_scopes({:$ne_price => '100'})
                            |
                            v
      Product.find(:all, :conditions => ['products.price != ?', 100])

  9. $in(集合内)查询
      Product.by_scopes({:$in_price => '100,150,200'})
                            |
                            v
      Product.find(:all, :conditions => ['products.price in ?', [100, 150, 200])

  10. $nin(集合外)查询
      Product.by_scopes({:$nin_price => '100,150,200'}) # 查询值 可以为符号','连接的字符串或数组
                            |
                            v
      Product.find(:all, :conditions => ['products.price not in ?', [100, 150, 200])

  11. $exists(存在或不为空值)查询
      Product.by_scopes({:$exists_price => value})  #注 value可为任意值
                            |
                            v
      Product.find(:all, :conditions => ['products.price is not null')

  12. $nexists(不存在或不为空值)查询
      Product.by_scopes({:$nexists_price => value})  #注 value可为任意值
                            |
                            v
      Product.find(:all, :conditions => ['products.price is null')

  13. 日期类查询
      Product.by_scopes({:$gte_created_at => '2012-12-12'})  #注 查询值 可为时间类型的字符串或时间类(包含 Date, DateTime, Time)
                            |
                            v
      Product.find(:all, :conditions => ["created_at >= '2012-12-12 00:00:00'")
=end

module FindHelper
	extend ActiveSupport::Concern

	included do
		self.send(:extend, Scope)
	end
end


