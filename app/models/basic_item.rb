class BasicItem < ActiveRecord::Base

  belongs_to :basic_subcategory
  has_many :outfit_items

  has_many :user_outfit, :through => :outfit_items

  has_attached_file :image, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250', :canvas => '100x100', :thumb => '150x150', :icon => '50x50', :other => '640x530'} ,
                    :convert_options => {:medium => "-gravity center -background transparent -extent 250x250"}
  validates_attachment :image, :content_type => {:content_type => ["image/jpg", "image/jpeg", "image/png"]}
  validates_presence_of :image

  #def self.colours
  #  [{:id => '#fff', :value => 'White'},
  #   {:id => '#000', :value => 'Black'},
  #   {:id => '#737373', :value => 'Dark Gray'},
  #   {:id => '#cccccc', :value => 'Light Gray'},
  #
  #   {:id => '#stripe', :value => 'Stripe'},
  #   {:id => '#9c792f', :value => 'Missing'},
  #   {:id => '#f0dbae', :value => 'Missing2'},
  #   {:id => '#fac272', :value => 'Light Orange'},
  #
  #   {:id => '#fff47b', :value => 'Light Yellow'},
  #   {:id => '#ee3e3e', :value => 'Red'},
  #   {:id => '#a31a1a', :value => 'Maroon'},
  #   {:id => '#f44895', :value => 'Pink'},
  #
  #   {:id => '#fdc4dc', :value => 'Light Pink'},
  #   {:id => '#bb59db', :value => 'Purple'},
  #   {:id => '#414489', :value => 'Blue'},
  #   {:id => '#4498f7', :value => 'Missing3'},
  #
  #
  #   {:id => '#bde2ff', :value => 'Light Sky Blue'},
  #   {:id => '#16bcbe', :value => 'Cyan'},
  #   {:id => '#47c73e', :value => 'Light Green'},
  #   {:id => '#2a7325', :value => 'Dark Green'},
  #  ]
  #end


  def self.colours
    [['White', '#fff'],
     ['Black', '#000'],
     ['Dark Grey', '#48484A'],
     ['Light Grey', '#B9B9B9'],

     ['Stripe', '#stripe'],
     ['Dark Brown', '#4C3730'],
     ['Light Brown', '#625944'],
     ['Light Orange', '#E9AB7C'],

     ['Yellow', '#E4D27E'],
     ['Red', '#E71E1B'],
     ['Maroon', '#52141A'],
     ['Pink', '#EA569D'],

     ['Light Pink', '#E4ABBB'],
     ['Purple', '#4C2F72'],
     ['Blue', '#0D3F98'],
     ['Teal', '#3D809A'],


     ['Light Blue', '#82BAC3'],
     ['Light Purple', '#D9C3D1'],
     ['Light Yellow', '#E5D6B3'],
     ['Green', '#70A278'],
    ]
  end

end