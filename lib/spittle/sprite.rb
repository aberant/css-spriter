module PNG
  class Sprite
    # imagining a setup where a sprite is just an array of images
    # nothing is calculated until render time
    # so merge_right would look like
    
    # def merge_right( other_img )
    #   images << other_img
    # end
    
    # and merge_left would be
    # def merge_left( other_image )
    #  images.unshift( other_image )
    # end
    
    # render would then take the head and merge_right the tail
  end
end