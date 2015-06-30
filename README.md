#FindHelper

## Example:
### Define a class Category
	class Category < ActiveRecord::Base
	  has_many :products
	end

### Define a class Product

    class Product < ActiveRecord::Base
    	include FindHelper    # import finder ability
    	
    	belongs_to :category

    	scope :product_name_like, ->(|name|)  {
    		where('name like ?', "%{name}%")
        }
        
        scope :price_gte,  ->(price) {
        	where('price_gte >= ?', price)
        }
        
        scope :category_name_like, ->(|cat_name|) {
          joins(:category).where('`cateogries.name` like ?', "%#{cat_name}%")
        }
        
        scope :category_ids, ->(cat_ids) {
            cat_ids = cat_ids.split(',') if cat_ids.is_a?(String)
            #support args likes this '1,2,3,4' to ['1', '2', '3', '4']
           
            where('category_id in (?)', cat_ids)
        }

    end
    

we will find those products which price > 50 and name include 'o'
  
  	price_gte = 50;
  	like_name = 'o'
  	
### Old 
  	Product.gte_price(price_gte).product_name(like_name)
  	# SELECT "products".* FROM "products"  WHERE (`products`.`price` >= 50)
  	  AND (`products`.`name` like '%o%')
  	
### Now
  	conditions = {gte_price: price_gte, product_name: like_name}  
  	
  	Product.by_scopes(conditions)
  	# SELECT "products".* FROM "products"  WHERE (`products`.`price` >= 50)
  	  AND (`products`.`name` like '%o%')
  	
### In addition， you can use it just like use where
  	
  	conditions = {gte_price: price_gte, product_name: like_name, category_id: 1}
  	
  	Product.by_scopes(conditions)
  	# SELECT "products".* FROM "products"  WHERE (`products`.`price` >= 50)
  	  AND (`products`.`name` like '%o%') AND (products.category_id = 1)

### Comparison query (you don't need define model scope)
   
   	# price < 50
   	Product.by_scopes({'$lt_price' => 50})
   	# SELECT "products".* FROM "products"  WHERE (products.price < 50)
   
   	# price <= 50
   	Product.by_scopes({'$lte_price' => 50})
   	# SELECT "products".* FROM "products"  WHERE (products.price <= 50)
   
   	# price > 50
   	Product.by_scopes({'$gt_price' => 50})
   	# SELECT "products".* FROM "products"  WHERE (products.price > 50)
   
   	# price >= 50
   	Product.by_scopes({'$gte_price' => 50})
   	# SELECT "products".* FROM "products"  WHERE (products.price >= 50) 
   
   	# price != 50
   	Product.by_scopes({'$ne_price' => 50})
   	# SELECT "products".* FROM "products"  WHERE (products.price != 50)
   
   	# price >= 50 and name like 'Red'
   	Product.by_scopes({'$ne_price' => 50, '$like_name' => 'Red'})
    # SELECT "products".* FROM "products"  WHERE (products.price != 50)
      AND (products.name like '%Red%')
    
    # is_online = true (tips: is_online is a boolean attribute)
    Product.by_scopes('is_online' => '1') or Product.by_scopes('is_online' => 'true')
    # SELECT "products".* FROM "products"  WHERE (products.is_online = 'true')
     
  	# category_id in [1,3,5]
  	Product.by_scopes('$in_category_id' => '1,3,5')
  	# or
  	Product.by_scopes('$in_category_id' => [1,3,5])
  	# SELECT "products".* FROM "products"  WHERE (products.category_id in ('1','3','5'))
  	
  	# category_id not id [2,4,6]
  	Product.by_scopes('$nin_category_id' => '2,4,6')
  	# or
  	Product.by_scopes('$nin_category_id' => [2,4,6])
  	# SELECT "products".* FROM "products"  WHERE (products.category_id not in ('2','4','6') )
  	
  	# name is not null
  	Product.by_scopes('$exists_name' => 'anything which do not care')
  	# SELECT "products".* FROM "products" WHERE (products.name is not null )
  	
  	# name is null	  	
    Product.by_scopes('$nexists_name' => 'anything which do not care')
  	# SELECT "products".* FROM "products" WHERE (products.name is  null )
  	
  	# date query (tips: created_at is a datetime attribute)
  	# created_at > '2015-06-30 12:00:00'
  	Product.by_scopes('$gt_created_at' => '2015-06-30 12:00:00')
  	# or
  	Product.by_scopes('$gt_created_at' => Time.parse('2015-06-30 12:00:00')
  	# SELECT "products".* FROM "products"  WHERE
  	    (products.created_at > '2015-06-30 12:00:00.000000')
  	




This project rocks and uses MIT-LICENSE.