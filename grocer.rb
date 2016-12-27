require "pry"
def consolidate_cart(cart)
  # code here
  cart_hashed={}
  cart.each do|item|
    item.each do |key, value|
    if !(cart_hashed.has_key?(key))
      cart_hashed[key]=value
      cart_hashed[key][:count]=1
    else
      cart_hashed[key][:count]+=1
      end
    end
  end
  cart_hashed
end

def apply_coupons(cart, coupons)
  # code here
  cart_w_discounts={}
  disc_items=[]
  coupons.each do|coupon|
    disc_items.push(coupon[:item])
  end
  cart.each do|item, description|
    if disc_items.include?(item)

      coupons.each do |coupon|
      # coupons_for_item=disc_items.count(item)
      if coupon[:item]==item
        if cart_w_discounts["#{item} W/COUPON"]
          if  cart_w_discounts[item][:count]>cart_w_discounts["#{item} W/COUPON"][:count]
          cart_w_discounts["#{item} W/COUPON"][:count]+=1
          cart_w_discounts[item][:count]-=coupon[:num]
          end
        else
          cart_w_discounts["#{item} W/COUPON"]={}
          cart_w_discounts["#{item} W/COUPON"][:price]= coupon[:cost]
          cart_w_discounts["#{item} W/COUPON"][:clearance]= description[:clearance]
          cart_w_discounts["#{item} W/COUPON"][:count]=1
          cart_w_discounts[item]= description
          cart_w_discounts[item][:count]-=coupon[:num]
          end
        end
      end
    else
      cart_w_discounts[item]=description
    end
  end
    cart_w_discounts
end

def apply_clearance(cart)
  # code here
  cart.each_value do |description|
      if description[:clearance]
        discount=(description[:price]* 0.20).round(2)
        description[:price]-=discount
      end
    end
    cart
end



def checkout(cart, coupons)
  # code here
  total=0
  hashed_cart= consolidate_cart(cart)
  discounted=apply_coupons(hashed_cart, coupons)
  puts discounted
  clearanced=apply_clearance(discounted)

  clearanced.each do |item, description|
    total+=description[:price]*description[:count]
  end
  if total>100
    total-= total*0.1
  end
  total
end
