function  thinned_image = image_thinning(image)

thinned_image=bwmorph(image,'thin','inf');