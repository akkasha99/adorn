namespace :db do

  task :seed_cat => :environment do

    puts "start"
    puts "delete all"
    BasicCategory.delete_all
    BasicSubcategory.delete_all
    BasicItem.delete_all

    puts "Add Categories"

    cat = BasicCategory.new(:name => 'Accessories')
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Accessories/Bandeau/Black.png"))
    cat.save!

    cat = BasicCategory.new(:name => 'Bottoms')
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Bottoms/Jeans/Black.png"))
    cat.save!

    cat = BasicCategory.new(:name => 'Outerwear')
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Blazer/Black.png"))
    cat.save!

    cat = BasicCategory.new(:name => 'Skirts Dresses')
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Skirts Dresses/Long Dress/Black.png"))
    cat.save!

    cat = BasicCategory.new(:name => 'Tops')
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Blouse/Black.png"))
    cat.save!


  end

  task :seed_sub_cat => :environment do

    puts "start"


    puts "Add Sub Categories"


    ###############################################################################################
    #
    #                           Accessories
    #
    ###############################################################################################

    puts "Accessories Start"

    man_cat = BasicCategory.where(:name => 'Accessories').first

    cat = BasicSubcategory.new(:name => 'Bandeau')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Accessories/Bandeau/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Belt')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Accessories/Belt/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'High Socks')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Accessories/High Socks/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Scarf')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Accessories/Scarf/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Tights')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Accessories/Tights/Black.png"))
    cat.save!

    puts "Accessories End"

    #########################################################################################


    ###############################################################################################
    #
    #                           Bottoms
    #
    ###############################################################################################

    puts "Bottoms Start"

    man_cat = BasicCategory.where(:name => 'Bottoms').first

    cat = BasicSubcategory.new(:name => 'Jeans')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Bottoms/Jeans/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Leggings')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Bottoms/Leggings/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Shorts')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Bottoms/Shorts/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Trousers')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Bottoms/Trousers/Black.png"))
    cat.save!


    puts "Bottoms End"

    #########################################################################################


    ###############################################################################################
    #
    #                           Outerwear
    #
    ###############################################################################################

    puts "Outerwear Start"

    man_cat = BasicCategory.where(:name => 'Outerwear').first

    cat = BasicSubcategory.new(:name => 'Blazer')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Blazer/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Cardigan')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Cardigan/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Jean Jacket')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Jean Jacket/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Leather Jacket')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Leather Jacket/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Overcoat')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Overcoat/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Pullover')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Pullover/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Vest')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Outerwear/Vest/Black.png"))
    cat.save!


    puts "Outerwear End"

    #########################################################################################


    ###############################################################################################
    #
    #                           Skirts Dresses
    #
    ###############################################################################################

    puts "Skirts Dresses Start"

    man_cat = BasicCategory.where(:name => 'Skirts Dresses').first

    cat = BasicSubcategory.new(:name => 'Long Dress')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Skirts Dresses/Long Dress/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Long Skirt')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Skirts Dresses/Long Skirt/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Mini Skirt')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Skirts Dresses/Mini Skirt/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Pencil Skirt')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Skirts Dresses/Pencil Skirt/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Slip Dress')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Skirts Dresses/Slip Dress/Black.png"))
    cat.save!


    puts "Skirts Dresses End"

    #########################################################################################


    ###############################################################################################
    #
    #                           Tops
    #
    ###############################################################################################

    puts "Tops Start"

    man_cat = BasicCategory.where(:name => 'Tops').first

    cat = BasicSubcategory.new(:name => 'Blouse')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Blouse/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Collar')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Collar/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Longsleeve')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Longsleeve/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Tank')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Tank/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Tee')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Tee/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'Turtle Neck')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/Turtle Neck/Black.png"))
    cat.save!

    cat = BasicSubcategory.new(:name => 'V-neck')
    cat.basic_category = man_cat
    cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/Tops/V-neck/Black.png"))
    cat.save!


    puts "Tops End"

    #########################################################################################


  end


  task :seed_basic_items => :environment do

    # BasicItem.delete_all


    puts "start for adding basic items"


    main_cats = BasicCategory.all

    main_cats.each do |main_cat|

      sub_cats = BasicSubcategory.where(:basic_category_id => main_cat.id).all


      sub_cats.each do |sub_cat|


        BasicItem.colours.each do |i|
          cat = BasicItem.new(:title => 'test', :description => "testing", :price => '50', :basic_subcategory_id => sub_cat.id, :color => i[1].to_s)
          cat.image = File.open(File.join("#{Rails.root}/db/Adoorn-Basics/#{main_cat.name}/#{sub_cat.name}/#{i[0].to_s}.png"))
          cat.save!
        end

      end


    end

  end


end